package org.curransoft.datacubesinfo

class Unit {
    static belongsTo = [quantity:Quantity]
    static hasMany = [facts:Fact]

    String name
    
    static constraints = {
    }
    String toString() { "$name" }
}
