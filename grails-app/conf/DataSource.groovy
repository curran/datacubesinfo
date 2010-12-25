dataSource {
    pooled = true
    driverClassName = "org.hsqldb.jdbcDriver"
    username = "sa"
    password = ""
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}
// environment specific settings
environments {
    development {
        dataSource {
            pooled = true
	          driverClassName = "com.mysql.jdbc.Driver"
	          username = "grails"
	          password = "g123"
	          dbCreate = "update"
	          url = "jdbc:mysql://localhost/udcserver"
        }
    }
    //To create/recreate the database:
    //drop database udcserver;create database udcserver;grant all on udcserver.* to 'grails' identified by 'g123';

    //To create the D2R mapping:
    //cd d2r
    //chmod +x ./generate-mapping
    //./generate-mapping -o mapping.n3 -d com.mysql.jdbc.Driver -u grails -p g123 jdbc:mysql://localhost/udcserver
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:hsqldb:mem:testDb"
        }
    }
    production {
        dataSource {
            dbCreate = "update"
            url = "jdbc:hsqldb:file:prodDb;shutdown=true"
        }
    }
}
