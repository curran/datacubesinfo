package org.curransoft.datacubesinfo
import grails.converters.*
class DataTableController {

    def scaffold = DataTable
    
    def test = {
      for(dt in DataTable.list())
        dt.delete()
      for(dtc in DataTableColumn.list())
        dtc.delete()
      for(dtr in DataTableRow.list())
        dtr.delete()
        
      def table = new DataTable(name:"US Population by State and Year")
      table.save()
      
      def stateColumn = new DataTableColumn(name:"State")
      table.addToColumns(stateColumn).save()
      
      def yearColumn = new DataTableColumn(name:"Year")
      table.addToColumns(yearColumn).save()
      
      def populationColumn = new DataTableColumn(name:"Population")
      table.addToColumns(populationColumn).save()
      
      def row1 = new DataTableRow()      
      table.addToRows(row1).save(flush:true)

      def stateEntry1 = new DataTableEntry(value:"MA")
      stateColumn.addToEntries(stateEntry1)
      row1.addToEntries(stateEntry1).save(flush:true)
      
      def yearEntry1 = new DataTableEntry(value:"1990")
      yearColumn.addToEntries(yearEntry1)
      row1.addToEntries(yearEntry1).save(flush:true)
      

//      def row2 = new DataTableRow()      
//      table.addToRows(row2).save(flush:true)
//
//      def stateEntry2 = new DataTableEntry(value:"AZ")
//      stateColumn.addToEntries(stateEntry2)
//      row2.addToEntries(stateEntry2).save(flush:true)

//      stateColumn.save(flush:true)
      
//      def yearColumn = new DataTableColumn(name:"Year")
//      table.addToColumns(yearColumn)
//      
//      def populationColumn = new DataTableColumn(name:"Population")
//      table.addToColumns(populationColumn)
        
      String s = ""
      s += "Data tables:"
      for(dt in DataTable.list())
        s += " "+dt.name
      s += "<br>Columns:"
      for(dtc in DataTableColumn.list())
        s += " "+dtc.name
      s += "<br>Rows:"
      for(dtr in DataTableRow.list())
        s += " "+dtr.id
      s += "<br>Entries:"
      for(dte in DataTableEntry.list())
        s += " "+dte.id
      render s
        


//      
//      def row1 = new DataTableRow()
//      row1.save()

//      def entry1 = new DataTableEntry(value:"MA",row:row1,column:stateColumn)
//      entry1.save()
//      row1.addToEntries(entry1).save()
//      table.addToRows(row1).save()
      //row1.addToEntries(entry1)
      //stateColumn.addToEntries(entry1)
      
    }
    def save = {
      render request.getFile("file").inputStream.text
      //render "Success!"
    }
}
