package org.curransoft.datacubesinfo

class Member {
    static belongsTo = [level:Level]

    String name
    
    static constraints = {
    }
    String toString() { "$name" }
}
