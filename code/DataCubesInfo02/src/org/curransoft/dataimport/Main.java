package org.curransoft.dataimport;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Stack;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JViewport;
import javax.swing.UIManager;
import javax.swing.WindowConstants;

public class Main {
	/**
	 * The stack of modal pages.
	 */
	static Stack<Page> pageStack = new Stack<Page>();

	static JFrame frame;
	static JViewport window;

	static MetadataStore metadataStore = new MetadataStore();

	public static void main(String[] args) {
		// set the native system look and feel
		try {
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		} catch (Exception e) {
			e.printStackTrace();
		}

		// Create the frame
		frame = new JFrame("Data Publishing Console");
		frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		frame.setBounds(0, 0, 600, 600);

		// Create the "window" - the mutable top level container
		window = new JViewport();

		// initialize the window to show the front page
		pushPage(makeFrontPage());
		frame.add(window);
		frame.setVisible(true);
	}

	@SuppressWarnings("serial")
	public static Page makeFrontPage() {
		// define the front page
		Page frontPage = new Page() {
			public void passMessage(Object message) {
				if (message instanceof Dataset){
					metadataStore.getDatasets().add((Dataset) message);
					
				}
			}
		};
		frontPage.add(new JLabel("What would you like to do?"));
		JButton newDatasetButton = new JButton("Define a new data set");
		newDatasetButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				// when the "Define a new data set" button is clicked,
				// push a "New Data Set" page onto the modal dialog stack
				pushPage(makeNewDataSetPage());
			}
		});

		frontPage.add(newDatasetButton);
		frontPage.add(new JButton("Modify an existing data set"));
		return frontPage;
	}

	@SuppressWarnings("serial")
	private static Page makeNewDataSetPage() {
		// define the "New Dataset" page
		Page newDatasetPage = new Page() {
			public void passMessage(Object message) {
				if (message instanceof Dataset)
					metadataStore.getDatasets().add((Dataset) message);
			}

		};

		newDatasetPage
				.setLayout(new BoxLayout(newDatasetPage, BoxLayout.Y_AXIS));
		newDatasetPage.add(new JLabel("What is the title of the data set?"));
		JTextField title = new JTextField();
		newDatasetPage.add(title);
		label(newDatasetPage, "Who created the data set?");
		JTextField creator = new JTextField();
		newDatasetPage.add(creator);
		newDatasetPage
				.add(new JLabel("Who published the data set originally?"));
		JTextField publisher = new JTextField();
		newDatasetPage.add(publisher);
		newDatasetPage.add(new JLabel("When was it published?"));
		JTextField publishDate = new JTextField();
		newDatasetPage.add(publishDate);
		JButton nextButton = new JButton("Add Tables");
		nextButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				pushPage(makeAddTablesPage());
			}
		});
		newDatasetPage.add(nextButton);
		JButton doneButton = new JButton("Done");
		doneButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				popPage(null);
			}
		});
		newDatasetPage.add(doneButton);

		return newDatasetPage;
	}

	@SuppressWarnings("serial")
	private static Page makeAddTablesPage() {
		// define the "New Table" page
		Page addTablePage = new Page() {
			public void passMessage(Object message) {
				if (message instanceof DataTable)
					metadataStore.getDataTables().add((DataTable) message);
			}
		};

		addTablePage.setLayout(new BoxLayout(addTablePage, BoxLayout.Y_AXIS));
		addTablePage.add(new JLabel("What?"));

		JButton doneButton = new JButton("Done");
		doneButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				popPage(null);
			}
		});
		addTablePage.add(doneButton);

		return addTablePage;
	}

	private static void pushPage(Page page) {
		pageStack.push(page);
		window.removeAll();
		window.add(page);
		frame.repaint();
	}

	/**
	 * Pops the current page off the page stack. Passes the given message to
	 * the new top page (like a function passes a return value to its caller).
	 * 
	 * @param message
	 *            can be null, in which case no message is passed
	 */
	private static void popPage(Object message) {
		/* Page pageWeAreLeaving = */pageStack.pop();
		Page pageWeAreGoingTo = pageStack.peek();

		if (message != null)
			pageWeAreGoingTo.passMessage(message);

		// swap the window out
		window.removeAll();
		window.add(pageWeAreGoingTo);

		// TODO swap the menu bar out

		frame.repaint();
	}

	private static void label(JComponent page, String labelText) {
		page.add(new JLabel(labelText));
	}
}
