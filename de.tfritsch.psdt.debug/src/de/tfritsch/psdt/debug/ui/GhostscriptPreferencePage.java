package de.tfritsch.psdt.debug.ui;

import java.io.File;

import org.eclipse.core.runtime.Platform;
import org.eclipse.jface.preference.*;
import org.eclipse.ui.IWorkbenchPreferencePage;
import org.eclipse.ui.IWorkbench;

import de.tfritsch.psdt.debug.IPSConstants;
import de.tfritsch.psdt.debug.PSPlugin;

/**
 * This class represents a preference page that
 * is contributed to the Preferences dialog. By 
 * subclassing <samp>FieldEditorPreferencePage</samp>, we
 * can use the field support built into JFace that allows
 * us to create a page that is small and knows how to 
 * save, restore and apply itself.
 * <p>
 * This page is used to modify preferences only. They
 * are stored in the preference store that belongs to
 * the PSPlugin class. That way, preferences can
 * be accessed directly via the preference store.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.ui.preferencePages"]/page/@class
 */
public class GhostscriptPreferencePage extends FieldEditorPreferencePage
    implements IWorkbenchPreferencePage {

    /**
     * Unique identifier for the Ghostscript preference page (value 
     * <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.ui.preferencePages"]/page/@id
     */
    public final static String ID = PSPlugin.ID + ".ghostscriptPreferencePage"; //$NON-NLS-1$

	/**
     * Public constructor needed for instantiation from plugin.xml
     */
    public GhostscriptPreferencePage() {
        super(GRID);
        setPreferenceStore(PSPlugin.getDefault().getPreferenceStore());
    }
    
    @Override
	public void createFieldEditors() {
		FileFieldEditor editor = new FileFieldEditor(
				IPSConstants.PREF_INTERPRETER, "&Interpreter:", true,
				getFieldEditorParent());
		String os = Platform.getOS();
		if (os.equals(Platform.OS_WIN32)) {
			editor.setFileExtensions(new String[] { "*.exe", "*.*" }); //$NON-NLS-1$ //$NON-NLS-2$
			editor.setFilterPath(new File("C:")); //$NON-NLS-1$
		} else if (os.equals(Platform.OS_LINUX)){
			editor.setFilterPath(new File("/usr/bin")); //$NON-NLS-1$
		}
		addField(editor);
    }

    //@Override
	public void init(IWorkbench workbench) {
    }
}
