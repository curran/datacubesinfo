package org.curransoft.datacubesinfo

class Level {
    static belongsTo = [dimension:Dimension]
    static hasMany = [members:Member]

    String name
    
    static constraints = {
    }
    String toString() { "$name" }
}
