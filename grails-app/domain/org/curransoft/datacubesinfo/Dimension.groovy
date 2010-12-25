package org.curransoft.datacubesinfo

class Dimension {
    String name
    static hasMany = [levels:Level]
    static constraints = {
    }
    String toString() { "$name" }
}
