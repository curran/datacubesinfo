package org.curransoft.datacubesinfo

class Fact {
    static belongsTo = [dataTable:DataTable]

    Cell cell
    Measure measure
    Unit unit

    double value
    
    static constraints = {
    }
}
