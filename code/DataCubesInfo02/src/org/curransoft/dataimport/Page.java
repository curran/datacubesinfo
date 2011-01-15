package org.curransoft.dataimport;

import javax.swing.Box;
import javax.swing.BoxLayout;

@SuppressWarnings("serial")
public class Page extends Box {

	public Page(int axis) {
		super(axis);
	}

	public Page() {
		super(BoxLayout.PAGE_AXIS);
	}

	/**
	 * Called when a message is passed to this page from a child page (like a
	 * function passes a return value to its caller).
	 * 
	 * @param message
	 *            can be null, in which case no message is passed
	 */
	public void passMessage(Object message) {
	}

	/**
	 * Removes everything from this panel and recreates the GUI elements based
	 * on the content of the model.
	 */
	public void refresh() {
	}
}
