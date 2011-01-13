package org.curransoft.datacubesinfo

class DataTableColumn {
    String name
    static belongsTo = DataTable
    DataTable table
    static hasMany = [entries:DataTableEntry]
    static constraints = {
    }
    String toString() { "$name" }
}
