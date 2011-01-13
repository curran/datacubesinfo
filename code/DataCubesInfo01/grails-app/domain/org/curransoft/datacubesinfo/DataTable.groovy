package org.curransoft.datacubesinfo

class DataTable {
    String name
    static hasMany = [rows:DataTableRow, columns:DataTableColumn]
    static constraints = {
    }
    String toString() { "$name" }
}
