package de.tfritsch.psdt.debug.model;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Path;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.variables.VariablesPlugin;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchManager;
import org.eclipse.debug.core.model.IProcess;
import org.eclipse.debug.core.model.LaunchConfigurationDelegate;
import org.eclipse.osgi.util.NLS;

import de.tfritsch.psdt.debug.IPSConstants;
import de.tfritsch.psdt.debug.PSPlugin;

/**
 * Launches PostScript program on Ghostscript interpreter
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.launchConfigurationTypes"]/launchConfigurationType/@delegate
 */
public class PSLaunchConfigurationDelegate extends LaunchConfigurationDelegate {

    /**
     * Unique identifier for the PostScript launch configuration type (value 
     * <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.core.launchConfigurationTypes"]/launchConfigurationType/@id
     */
    public final static String ID = PSPlugin.ID + ".launchConfigurationType"; //$NON-NLS-1$

	//@Override
	public void launch(ILaunchConfiguration cfg, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {
        String exe = verifyInterpreter();
        String psFile = verifyPSFile(cfg);
        List<String> cmdLineList = new ArrayList<String>();
        cmdLineList.add(exe);
        for (String s : DebugPlugin.parseArguments(cfg.getAttribute(IPSConstants.ATTR_GS_ARGUMENTS, ""))) { //$NON-NLS-1$
        	cmdLineList.add(s);
        }
        if (mode.equals(ILaunchManager.RUN_MODE)) {
        	cmdLineList.add(psFile);
        } else if (mode.equals(ILaunchManager.DEBUG_MODE)) {
            cmdLineList.add(PSPlugin.getFile("psdebug.ps").toOSString()); //$NON-NLS-1$
            cmdLineList.add(PSPlugin.getFile("stdin.ps").toOSString()); //$NON-NLS-1$
        } else {
            abort(NLS.bind("invalid launch mode \"{0}\"", mode), null);
        }
        String[] cmdLine = cmdLineList.toArray(new String[0]);
        File workingDir = verifyWorkingDirectory(cfg);
        String[] env = DebugPlugin.getDefault().getLaunchManager().getEnvironment(cfg);
        Process p = DebugPlugin.exec(cmdLine, workingDir, env);
        IProcess process = DebugPlugin.newProcess(launch, p, renderProcessLabel(cmdLine));
        process.setAttribute(DebugPlugin.ATTR_PATH, cmdLine[0]);
        process.setAttribute(DebugPlugin.ATTR_LAUNCH_TIMESTAMP, launch.getAttribute(DebugPlugin.ATTR_LAUNCH_TIMESTAMP));
        process.setAttribute(IProcess.ATTR_CMDLINE, DebugPlugin.renderArguments(cmdLine, null));
        if (workingDir != null)
        	process.setAttribute(DebugPlugin.ATTR_WORKING_DIRECTORY, workingDir.getAbsolutePath());
        process.setAttribute(DebugPlugin.ATTR_ENVIRONMENT, renderEnvironment(env));
        process.setAttribute(IProcess.ATTR_PROCESS_TYPE, "PostScript"); //$NON-NLS-1$
        if (mode.equals(ILaunchManager.DEBUG_MODE)) {
            List<PSToken> tokens = createTokens(psFile);
           	PSDebugTarget target = new PSDebugTarget(process, psFile, tokens);
           	launch.addDebugTarget(target);
        }
    }
    
    private void abort(String message, Throwable e) throws CoreException {
        IStatus status = new Status(IStatus.ERROR, PSPlugin.ID, message, e);
        throw new CoreException(status);
    }
    
    // copied from org.eclipse.jdt.internal.launching.StandardVMRunner
    private static String renderProcessLabel(String[] commandLine) {
        String timeStamp = DateFormat.getDateTimeInstance(
                DateFormat.MEDIUM, DateFormat.MEDIUM).format(new Date());
        return NLS.bind("{0} ({1})", commandLine[0], timeStamp); //$NON-NLS-1$
    }

    private static String renderEnvironment(String[] env) {
    	if (env == null)
    		return null;
    	StringBuffer buff = new StringBuffer();
    	for (String s : env) {
    		buff.append(s).append("\n"); //$NON-NLS-1$
    	}
    	return buff.toString();
    }

    private List<PSToken> createTokens(String psFile) throws CoreException {
    	List<PSToken> tokens = new ArrayList<PSToken>();
    	try {
    		PSInputStream input = new PSInputStream(new FileInputStream(psFile));
    		PSToken token = input.readToken();
    		while (token != null) {
    			tokens.add(token);
    			token = input.readToken();
    		}
    		input.close();
    	} catch (IOException e) {
    		abort(e.toString(), e);
    	}
    	return tokens;
    }
    
    String verifyPSFile(ILaunchConfiguration configuration) throws CoreException {
        String psFile = configuration.getAttribute(IPSConstants.ATTR_PROGRAM, (String)null);
        if (psFile == null) {
            abort("PostScript program not specified.", null);
        }
        if (!(new File(psFile)).exists()) {
            abort(NLS.bind("PostScript program \"{0}\" not existing.", psFile), null);
        }
        return psFile;
    }

    String verifyInterpreter() throws CoreException {
        String exe = PSPlugin.getDefault().getPreferenceStore().getString(IPSConstants.PREF_INTERPRETER);
        if (exe == null || exe.length() == 0) {
            abort("Interpreter not specified", null);
        }
        return exe;
    }
    
    // copied from org.eclipse.jdt.launching.AbstractJavaLaunchConfigurationDelegate
	File verifyWorkingDirectory(ILaunchConfiguration configuration) throws CoreException {
		IPath path = getWorkingDirectoryPath(configuration);
		if (path == null)
			return null;
		else {
			File dir = new File(path.toOSString());
			return dir;
		}
	}
	
    // copied from org.eclipse.jdt.launching.AbstractJavaLaunchConfigurationDelegate
    IPath getWorkingDirectoryPath(ILaunchConfiguration config) throws CoreException {
    	String path = config.getAttribute(DebugPlugin.ATTR_WORKING_DIRECTORY, (String) null);
    	if (path != null) {
    		path = VariablesPlugin.getDefault().getStringVariableManager().performStringSubstitution(path);
    		return new Path(path);
    	}
    	return null;
    }
}
