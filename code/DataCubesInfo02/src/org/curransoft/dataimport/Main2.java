package org.curransoft.dataimport;

import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Stack;

import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JViewport;
import javax.swing.UIManager;
import javax.swing.WindowConstants;

public class Main2 {
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
		Page frontPage = new Page(BoxLayout.PAGE_AXIS) {
			public void passMessage(Object message) {
				if (message instanceof Dimension) {
					metadataStore.getDimensions().add((Dimension) message);
					refresh();
					System.out.println("here in passMessage");
				}
			}

			public void refresh() {
				removeAll();
				
				add(Box.createVerticalGlue());
				
				add(center(new JLabel("What would you like to do?")));
				JButton newDatasetButton = new JButton("Define a new dimension");
				newDatasetButton.addActionListener(new ActionListener() {
					public void actionPerformed(ActionEvent arg0) {
						pushPage(makeNewDimensionPage());
					}
				});
				add(center(newDatasetButton));
				System.out.println("here in refresh");
				add(center(new JLabel("Dimensions:")));
				for (Dimension d : metadataStore.getDimensions()) {
					System.out.println("d.getName() = " + d.getName());
					add(new JLabel(" " + d.getName()));
				}
				
				add(Box.createVerticalGlue());
			}

			public String toString() {
				return "front page";
			}
		};

		return frontPage;
	}

	@SuppressWarnings("serial")
	private static Page makeNewDimensionPage() {
		// define the "New Dimension" page
		Page newDimensionPage = new Page() {
			public void passMessage(Object message) {
				if (message instanceof Dimension)
					metadataStore.getDimensions().add((Dimension) message);
			}

			public void refresh() {
				JButton whatsADimensionButton = new JButton(
						"What is a dimension?");
				whatsADimensionButton.addActionListener(new ActionListener() {
					public void actionPerformed(ActionEvent arg0) {
						Page page = new Page();
						JTextArea textArea = new JTextArea();
						textArea.setText("A dimension is a hierarchy of abstract regions called members. "
								+ "Each member is contained within another member; its parent member. "
								+ "A dimension has a single member which represents its entirety, the 'all' member, "
								+ "which is ultimately the parent of all members in that dimension. "
								+ "This 'all' member is the only member that has no parents. "
								+ "Each member belongs to a certain level in the hierarchy. "
								+ "The 'all' member is in a level in which it is the only member. "
								+ "Each level has a parent level, except for the 'all' level, "
								+ "which is the topmost level of the dimension and has no parent level.");
						page.add(textArea);
						JButton doneButton = new JButton("Done");
						doneButton.addActionListener(new ActionListener() {
							public void actionPerformed(ActionEvent arg0) {
								popPage(null);
							}
						});
						pushPage(page);
					}
				});
				add(whatsADimensionButton);

				JLabel nameLabel = new JLabel(
						"What is the name of the dimension?");
				nameLabel
						.setToolTipText("e.g. 'Time', 'Space', 'Industry', 'Species'");
				add(nameLabel);

				final JTextField nameField = new JTextField();
				add(nameField);

				JButton doneButton = new JButton("Done");
				doneButton.addActionListener(new ActionListener() {
					public void actionPerformed(ActionEvent arg0) {
						popPage(new Dimension(nameField.getText()));
					}
				});
				add(doneButton);
			}
		};

		return newDimensionPage;
	}

	private static void pushPage(Page page) {
		page.refresh();
		pageStack.push(page);
		window.removeAll();
		window.add(page);
		frame.repaint();
	}

	/**
	 * /** Pops the current page off the page stack. Passes the given message to
	 * the new top page (like a function passes a return value to its caller).
	 * 
	 * @param message
	 *            can be null, in which case no message is passed
	 */
	private static void popPage(Object message) {
		/* Page pageWeAreLeaving = */pageStack.pop();
		Page pageWeAreGoingTo = pageStack.peek();

		if (message != null) {
			pageWeAreGoingTo.passMessage(message);
			System.out.println("passing message to " + pageWeAreGoingTo);
			System.out.println("message = " + message);
		}

		// swap the window out
		window.removeAll();
		window.add(pageWeAreGoingTo);

		// TODO swap the menu bar out

		frame.repaint();
	}

	private static Component center(JComponent c) {
		c.setAlignmentX(Component.CENTER_ALIGNMENT);
		return c;
	}
}
