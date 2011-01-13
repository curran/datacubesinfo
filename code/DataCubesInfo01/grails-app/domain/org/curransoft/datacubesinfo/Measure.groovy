package org.curransoft.datacubesinfo

class Measure {
    static hasMany = [facts:Fact]
    aggregationFunction AggregationFunction
    
    String name
    
    static constraints = {
    }
    String toString() { "$name" }
}
