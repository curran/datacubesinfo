package org.curransoft.dataimport;

import java.util.ArrayList;
import java.util.List;

public class MetadataStore {
	List<Dataset> datasets = new ArrayList<Dataset>();
	List<Dimension> dimensions = new ArrayList<Dimension>();
	List<DataTable> dataTables = new ArrayList<DataTable>();

	
	public List<Dataset> getDatasets() {
		return datasets;
	}

	public List<Dimension> getDimensions() {
		return dimensions;
	}

	public List<DataTable> getDataTables() {
		return dataTables;
	}

}
