package org.curransoft.dataimport;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Stack;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.JViewport;
import javax.swing.UIManager;
import javax.swing.WindowConstants;

public class Main {
	/**
	 * The stack of modal pages.
	 */
	static Stack<JPanel> pageStack = new Stack<JPanel>();

	static JFrame frame;
	static JViewport window;

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
		pushPage(makeFrontJPanel());
		frame.add(window);
		frame.setVisible(true);
	}

	public static JPanel makeFrontJPanel() {
		// define the front page
		JPanel frontJPanel = new JPanel();
		frontJPanel.add(new JLabel("What would you like to do?"));
		JButton newDatasetButton = new JButton("Define a new data set");
		newDatasetButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				// when the "Define a new data set" button is clicked,
				// push a "New Data Set" page onto the modal dialog stack
				pushPage(makeNewDataSetJPanel());
			}
		});

		frontJPanel.add(newDatasetButton);
		frontJPanel.add(new JButton("Modify an existing data set"));
		return frontJPanel;
	}

	private static JPanel makeNewDataSetJPanel() {
		// define the "New Dataset" page
		JPanel newDatasetJPanel = new JPanel();

		newDatasetJPanel
				.setLayout(new BoxLayout(newDatasetJPanel, BoxLayout.Y_AXIS));
		newDatasetJPanel.add(new JLabel("What is the title of the data set?"));
		JTextField title = new JTextField();
		newDatasetJPanel.add(title);
		label(newDatasetJPanel, "Who created the data set?");
		JTextField creator = new JTextField();
		newDatasetJPanel.add(creator);
		newDatasetJPanel
				.add(new JLabel("Who published the data set originally?"));
		JTextField publisher = new JTextField();
		newDatasetJPanel.add(publisher);
		newDatasetJPanel.add(new JLabel("When was it published?"));
		JTextField publishDate = new JTextField();
		newDatasetJPanel.add(publishDate);
		JButton nextButton = new JButton("Add Tables");
		nextButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				pushPage(makeAddTablesJPanel());
			}
		});
		newDatasetJPanel.add(nextButton);
		JButton doneButton = new JButton("Done");
		doneButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				popPage();
			}
		});
		newDatasetJPanel.add(doneButton);

		return newDatasetJPanel;
	}
	
	private static JPanel makeAddTablesJPanel() {
		// define the "New Dataset" page
		JPanel addTableJPanel = new JPanel();

		addTableJPanel
				.setLayout(new BoxLayout(addTableJPanel, BoxLayout.Y_AXIS));
		addTableJPanel.add(new JLabel("What?"));
		
		JButton doneButton = new JButton("Done");
		doneButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				popPage();
			}
		});
		addTableJPanel.add(doneButton);

		return addTableJPanel;
	}

	private static void pushPage(JPanel page) {
		pageStack.push(page);
		window.removeAll();
		window.add(page);
		frame.repaint();
	}

	private static void popPage() {
		pageStack.pop();
		window.removeAll();
		window.add(pageStack.peek());
		frame.repaint();
	}

	private static void label(JComponent page, String labelText) {
		page.add(new JLabel(labelText));
	}
}
