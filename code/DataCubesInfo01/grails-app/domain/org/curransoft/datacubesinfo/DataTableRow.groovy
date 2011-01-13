package org.curransoft.datacubesinfo

class DataTableRow {
    static belongsTo = DataTable
    DataTable table
    static hasMany = [entries:DataTableEntry]
    static constraints = {
    }
    //String toString() { "${row.id}" }
}
