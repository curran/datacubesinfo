package org.curransoft.datacubesinfo

class Quantity {
    static hasMany = [measures:Measure,units:Unit]

    String name
    
    static constraints = {
    }
    String toString() { "$name" }
}
