package org.curransoft.datacubesinfo

class AggregationFunction {
    static hasMany = [measures:Measure]

    String name
    
    static constraints = {
    }
    String toString() { "$name" }
}
