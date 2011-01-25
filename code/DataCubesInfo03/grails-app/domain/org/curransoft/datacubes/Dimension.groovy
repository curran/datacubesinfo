package org.curransoft.datacubes

class Dimension {
    static hasMany = [ levels : Level ]
    String name
    static constraints = {
    }
}
