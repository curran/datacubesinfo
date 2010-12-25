package org.curransoft.datacubesinfo

class DataTableColumnController {

    def scaffold = DataTableColumn
    
    def add = {
        DataTable.get(1).addToColumns(new DataTableColumn(name:"Foo2"))
        render "foo2"//DataTable.get(1).name
    }
}
