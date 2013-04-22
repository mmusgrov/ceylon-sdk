import ceylon.test { assertEquals, assertTrue, assertFalse, fail, suite }
import ceylon.time { date, Date, Period, dateTime, time }
import ceylon.time.base { december, monday, january, november, february, april, tuesday, october, sunday, wednesday, september, july, march, friday, saturday, DayOfWeek, Month, years }

// Constants
Boolean leapYear = true;
Date data_1982_12_13 = date( 1982, december, 13);

shared void runDateTests(String suiteName="Date tests") {
    suite(suiteName,
        "Testing July 24 -586" -> test_sun_jul_24_minus586,
        "Testing December 05 -168" -> test_wed_dec_05_minus168,
        "Testing September 24 70" -> test_wed_sep_24_70,
        
        "Testing January 01 1900" -> test_mon_jan_01_1900,
        "Testing October 29 1974" -> test_tue_oct_29_1974,
        "Testing December 13 1982" -> test_mon_dec_13_1982,
        "Testing December 31 1999" -> test_mon_dec_31_1999,
        "Testing January 1 2000" -> test_mon_jan_01_2000,
        "Testing January 31 2000" -> test_mon_jan_31_2000,
        "Testing February 29 2000" -> test_tue_feb_29_2000,
        "Testing December 31 2000" -> test_sun_dec_31_2000,
        "Testing February 29 2012" -> test_wed_feb_29_2012,
        
        "Testing invalid dates: January 0 2013" -> test_invalid_date_jan_0,
        "Testing invalid dates: February 29 2013" -> test_invalid_date_feb_29,
        "Testing invalid dates: maximum year" -> test_invalid_date_maximum_year,
        "Testing invalid dates: minimum year" -> test_invalid_date_minimum_year,
        
        "Testing leap year rules: 2400" -> test_2400_is_leapYear,
        "Testing leap year rules: 2200" -> test_2200_is_not_leapYear,
        "Testing leap year rules: 2100" -> test_2100_is_not_leapYear,
        "Testing leap year rules: 2012" -> test_2012_is_leapYear,
        "Testing leap year rules: 2011" -> test_2011_is_not_leapYear,
        "Testing leap year rules: 2008" -> test_2008_is_leapYear,
        "Testing leap year rules: 2000" -> test_2000_is_leapYear,
        "Testing leap year rules: 1900" -> test_1900_is_not_leapYear,
        "Testing leap year rules: 1600" -> test_1600_is_leapYear,
        "Testing leap year rules: year 0" -> test_0000_is_leapYear,
        "Testing leap year rules: year 1" -> test_0001_is_not_leapYear,
        "Testing leap year rules: year 4" -> test_0004_is_leapYear,
        "Testing leap year rules: year 33" -> test_0033_is_not_leapYear,
        "Testing leap year rules: year 100" -> test_0100_is_not_leapYear,
        "Testing leap year rules: year 400" -> test_0400_is_leapYear,
        
        //http://en.wikipedia.org/wiki/ISO_week_date
        "Testing week of year: April 28 2009" -> test_weekOfYear_2009_apr_28,
        "Testing week of year: December 16 2012" -> test_weekOfYear_2012_dec_16,
        "Testing week of year: January 1 2005" -> test_weekOfYear_2005_jan_01,
        "Testing week of year: January 1 2005" -> test_weekOfYear_2005_jan_01,
        "Testing week of year: January 2 2005" -> test_weekOfYear_2005_jan_02,
        "Testing week of year: January 31 2005" -> test_weekOfYear_2005_dec_31,
        "Testing week of year: January 1 2007" -> test_weekOfYear_2007_jan_01,
        "Testing week of year: December 30 2007" -> test_weekOfYear_2007_dec_30,
        "Testing week of year: December 31 2007" -> test_weekOfYear_2007_dec_31,
        "Testing week of year: January 1 2008" -> test_weekOfYear_2008_jan_01,
        "Testing week of year: December 28 2008" -> test_weekOfYear_2008_dec_28,
        "Testing week of year: December 29 2009" -> test_weekOfYear_2008_dec_29,
        "Testing week of year: December 30 2008" -> test_weekOfYear_2008_dec_30,
        "Testing week of year: December 31 2008" -> test_weekOfYear_2008_dec_31,
        "Testing week of year: January 1 2009" -> test_weekOfYear_2009_jan_01,
        "Testing week of year: December 31 2009" -> test_weekOfYear_2009_dec_31,
        "Testing week of year: January 1 2010" -> test_weekOfYear_2010_jan_01,
        "Testing week of year: January 2 2010" -> test_weekOfYear_2010_jan_02,
        "Testing week of year: January 3 2010" -> test_weekOfYear_2010_jan_03,
        
        "Testing date plusDays" -> testPlusDays,
        "Testing date minusDays" -> testMinusDays,
        "Testing date minusDays" -> testMinusDays
    );
}

// Table of test data from the book Calendrical Calculations
shared void test_sun_jul_24_minus586() => assertGregorianDate(-586, july, 24, sunday, !leapYear, 205);
shared void test_wed_dec_05_minus168() => assertGregorianDate(-168, december, 5, wednesday, leapYear, 340);
shared void test_wed_sep_24_70() => assertGregorianDate(70, september, 24, wednesday, !leapYear, 267);

shared void test_mon_jan_01_1900() => assertGregorianDate(1900, january, 1, monday, !leapYear, 1);
shared void test_tue_oct_29_1974() => assertGregorianDate(1974, october, 29, tuesday, !leapYear, 302);
shared void test_mon_dec_13_1982() => assertGregorianDate(1982, december, 13, monday, !leapYear, 347);
shared void test_mon_dec_31_1999() => assertGregorianDate(1999, december, 31, friday, !leapYear, 365);
shared void test_mon_jan_01_2000() => assertGregorianDate(2000, january, 1, saturday, leapYear, 1);
shared void test_mon_jan_31_2000() => assertGregorianDate(2000, january, 31, monday, leapYear, 31);
shared void test_tue_feb_29_2000() => assertGregorianDate(2000, february, 29, tuesday, leapYear, 60);
shared void test_sun_dec_31_2000() => assertGregorianDate(2000, december, 31, sunday, leapYear, 366);
shared void test_wed_feb_29_2012() => assertGregorianDate(2012, february, 29, wednesday, leapYear, 60);

shared void test_invalid_date_jan_0() => assertException("Invalid date", 2013, january, 0);
shared void test_invalid_date_feb_29() => assertException("Invalid date", 2013, february, 29);
shared void test_invalid_date_feb_30() => assertException("Invalid date", 2012, february, 30);
shared void test_invalid_date_apr_31() => assertException("Invalid date", 2012, april, 31);
shared void test_invalid_date_jan_32() => assertException("Invalid date", 2013, january, 32);
shared void test_invalid_date_maximum_year() => assertException("Invalid year", years.maximum+1, february, 29);
shared void test_invalid_date_minimum_year() => assertException("Invalid year", years.minimum-1, february, 29);

shared void test_2400_is_leapYear() => assertTrue( date(2400, january, 1 ).leapYear, "2400 is leap year" );
shared void test_2200_is_not_leapYear() => assertFalse( date(2200, january, 1 ).leapYear, "2200 is not leap year" );
shared void test_2100_is_not_leapYear() => assertFalse( date(2100, january, 1 ).leapYear, "2010 is not leap year" );
shared void test_2012_is_leapYear() => assertTrue( date(2012, january, 1 ).leapYear, "2012 is leap year" );
shared void test_2011_is_not_leapYear() => assertFalse( date(2011, january, 1 ).leapYear, "2011 is not leap year" );
shared void test_2008_is_leapYear() => assertTrue( date(2008, january, 1 ).leapYear, "2008 is leap year" );
shared void test_2000_is_leapYear() => assertTrue( date(2000, january, 1 ).leapYear, "2000 is leap year" );
shared void test_1900_is_not_leapYear() => assertFalse( date(1900, january, 1 ).leapYear, "1900 is not leap year" );
shared void test_1600_is_leapYear() => assertTrue( date(1600, january, 1 ).leapYear, "1600 is leap year" );
shared void test_0000_is_leapYear() => assertTrue( date(0000, january, 1 ).leapYear, "Year 0 is leap year" );
shared void test_0001_is_not_leapYear() => assertFalse( date(0001, january, 1 ).leapYear, "Year 1 is not leap year" );
shared void test_0004_is_leapYear() => assertTrue( date(0004, january, 1 ).leapYear, "Year 4 is leap year" );
shared void test_0033_is_not_leapYear() => assertFalse( date(033, january, 1 ).leapYear, "Year 33 is not leap year" );
shared void test_0100_is_not_leapYear() => assertFalse( date(100, january, 1 ).leapYear, "Year 100 is not leap year" );
shared void test_0400_is_leapYear() => assertFalse( date(400, january, 1 ).leapYear, "Year 400 is leap year" );

shared void test_weekOfYear_2009_apr_28() => assertEquals( date(2009, april, 28).weekOfYear, 18);
shared void test_weekOfYear_2012_dec_16() => assertEquals( date(2012, december, 16).weekOfYear, 50);

//http://en.wikipedia.org/wiki/ISO_week_date
//http://www.personal.ecu.edu/mccartyr/isowdcal.html
shared void test_weekOfYear_2005_jan_01() => assertEquals( date(2005, january, 1).weekOfYear, 53);
shared void test_weekOfYear_2005_jan_02() => assertEquals( date(2005, january, 2).weekOfYear, 53);
shared void test_weekOfYear_2005_dec_31() => assertEquals( date(2005, december, 31).weekOfYear, 52);
shared void test_weekOfYear_2007_jan_01() => assertEquals( date(2007, january, 1).weekOfYear, 1);
shared void test_weekOfYear_2007_dec_30() => assertEquals( date(2007, december, 30).weekOfYear, 52);
shared void test_weekOfYear_2007_dec_31() => assertEquals( date(2007, december, 31).weekOfYear, 1);
shared void test_weekOfYear_2008_jan_01() => assertEquals( date(2008, january, 1).weekOfYear, 1);
shared void test_weekOfYear_2008_dec_28() => assertEquals( date(2008, december, 28).weekOfYear, 52);
shared void test_weekOfYear_2008_dec_29() => assertEquals( date(2008, december, 29).weekOfYear, 1);
shared void test_weekOfYear_2008_dec_30() => assertEquals( date(2008, december, 30).weekOfYear, 1);
shared void test_weekOfYear_2008_dec_31() => assertEquals( date(2008, december, 31).weekOfYear, 1);
shared void test_weekOfYear_2009_jan_01() => assertEquals( date(2009, january, 1).weekOfYear, 1);
shared void test_weekOfYear_2009_dec_31() => assertEquals( date(2009, december, 31).weekOfYear, 53);
shared void test_weekOfYear_2010_jan_01() => assertEquals( date(2010, january, 1).weekOfYear, 53);
shared void test_weekOfYear_2010_jan_02() => assertEquals( date(2010, january, 2).weekOfYear, 53);
shared void test_weekOfYear_2010_jan_03() => assertEquals( date(2010, january, 3).weekOfYear, 53);

shared void testDatePlusDays() {
    assertEquals( data_1982_12_13.plusDays( 0 ), data_1982_12_13 );
    assertEquals( data_1982_12_13.plusDays( 5 ), date( 1982, december, 18 ) );
    assertEquals( data_1982_12_13.plusDays( 45 ), date( 1983, january, 27 ) );
    assertEquals( data_1982_12_13.plusDays( 10954 ), date( 2012, december, 9 ) );
}

shared void testDateMinusDays() {
    assertEquals( data_1982_12_13.minusDays( 5 ), date( 1982, december, 8 ) );
    assertEquals( data_1982_12_13.minusDays( 0 ), data_1982_12_13 );
    assertEquals( date( 2012, december, 9 ).minusDays( 10954 ), data_1982_12_13 );
}

shared void testDatePlusMonthsLessDaysException() {
    assertEquals( date(1983, february, 28), date(1982,december,31).plusMonths(2));
}

shared void testDatePlusMonths() {
    assertEquals( data_1982_12_13.plusMonths(0), data_1982_12_13 );
    assertEquals( data_1982_12_13.plusMonths(1), date( 1983, january, 13) );
    assertEquals( data_1982_12_13.plusMonths(12), date( 1983, december, 13) );
    assertEquals( data_1982_12_13.plusMonths(36), date( 1985, december, 13) );

    value data_2000_01_31 = date( 2000, january, 31 );
    assertEquals( data_2000_01_31.plusMonths(14), date( 2001, march, 31) );
}

shared void testDateMinusMonths() {
    assertEquals( data_1982_12_13.minusMonths(0), data_1982_12_13 );
    assertEquals( data_1982_12_13.minusMonths(1), date( 1982, november, 13) );
    assertEquals( data_1982_12_13.minusMonths(12), date( 1981, december, 13) );
}

shared void testDateMinusLessDaysException() {
    assertEquals( date(1982,november,30), date(1982,december,31).minusMonths(1));
}

shared void testDatePlusYears() {
    assertEquals( data_1982_12_13.plusYears(0), data_1982_12_13 );
    assertEquals( data_1982_12_13.plusYears(18), date( 2000, december, 13) );
    assertEquals( data_1982_12_13.plusYears(30), date( 2012, december, 13) );
}

shared void testPlusYearsLessDays() {
    assertEquals( date(2013, february, 28), date(2012, february, 29).plusYears(1));
}

shared void testDateMinusYears() {
    value data_2000_01_31 = date( 2000, january, 31);
    assertEquals( data_2000_01_31.minusYears(1), date( 1999, january, 31) );
    assertEquals( data_1982_12_13.minusYears(10), date( 1972, december, 13) );
}

shared void testMinusYearsLessDays() {
    assertEquals( date(2011, february, 28), date(2012, february, 29).minusYears(1));
}

shared void testDatePlusWeeks() {
    assertEquals( data_1982_12_13.plusWeeks(1).dayOfWeek, data_1982_12_13.dayOfWeek );
    assertEquals( data_1982_12_13.plusWeeks(1), date( 1982, december, 20) );
    assertEquals( data_1982_12_13.plusWeeks(3), date( 1983, january, 3) );
}

shared void testDateMinusWeeks(){
    assertEquals( data_1982_12_13.minusWeeks(1), date( 1982, december, 6) );
    assertEquals( data_1982_12_13.minusWeeks(3), date( 1982, november, 22) );
    assertEquals( data_1982_12_13.minusWeeks(3).dayOfWeek, date( 1982, november, 22).dayOfWeek );
}

shared void testWithDay() {
    assertEquals( data_1982_12_13.withDay(13), data_1982_12_13 );
    assertEquals( data_1982_12_13.withDay(17), date( 1982, december, 17) );
    assertTrue( data_1982_12_13.withDay(17) <=> date( 1982, december, 17) == equal);
}

shared void testWithDay40() {
    try {
        data_1982_12_13.withDay(40);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared void testWithDay0() {
    try {
        data_1982_12_13.withDay(0);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared void testWithDayNegative() {
    try {
        data_1982_12_13.withDay(-10);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared void testWithDay29FebNotLeap() {
    try {
        date(2011, february,1).withDay(29);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared void testWithDay29FebLeap() {
    assertEquals( date(2012, february,1).withDay(29), date(2012, february, 29) );
}    


shared void testWithMonthLessDaysException() {
    try {
        date(2012, december, 31).withMonth(february);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared void testWithMonth() {
    assertEquals( data_1982_12_13, data_1982_12_13.withMonth(december) );
    assertEquals( date( 1982, january, 13), data_1982_12_13.withMonth(january) );
    assertTrue( data_1982_12_13.withMonth(january) <=> date( 1982, january, 13) == equal);
}

shared void testWithYear() {
    assertEquals( data_1982_12_13.withYear(1982), data_1982_12_13 );
    assertEquals( data_1982_12_13.withYear(2000), date( 2000, december, 13) );
    assertEquals( data_1982_12_13.withYear(1800), date( 1800, december, 13) );
}

shared void testWithYearLeap() {
    try {
        date( 2012, february, 29).withYear(2011);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date value"));
    }
}

shared void testOrdinal() {
    Date data_1983_01_01 = date( 1983, january, 1 );
    variable value cont = 0;
    for ( Date date in data_1982_12_13..data_1983_01_01 ) {
        assertEquals( date, data_1982_12_13.plusDays(cont++) );
    }
}

shared void testPlusPeriod_Date() {
    value period_0001_02_03 = Period {
        years = 1;
        months = 2;
        days = 3;
    };
    value newDataAmount = data_1982_12_13.plus( period_0001_02_03 );
    assertEquals( newDataAmount.year, 1984 );
    assertEquals( newDataAmount.month, february );
    assertEquals( newDataAmount.day, 16 );
}

shared void testMinusPeriod_Date() {
    value period_0001_02_03 = Period {
        years = 1;
        months = 2;
        days = 3;
    };
    value newDataAmount = data_1982_12_13.minus( period_0001_02_03 );
    assertEquals( newDataAmount.year, 1981 );
    assertEquals( newDataAmount.month, october );
    assertEquals( newDataAmount.day, 10 );
}

shared void testPredecessor() {
    assertEquals(data_1982_12_13.predecessor, date(1982, december, 12));
}

shared void testSuccessor() {
    assertEquals(data_1982_12_13.successor, date(1982, december, 14));
}

shared void testString() {
    assertEquals( data_1982_12_13.string, "1982-12-13" );
    assertEquals( date(2012, january, 1 ).string, "2012-01-01" );
}

shared void testAt() {
    assertAt(2013, january, 1, 10, 20, 15, 999);
    assertAt(2012, february, 29, 9, 10, 30, 0);
}

shared void testAtInvalidHour() {
    try {
        data_1982_12_13.at( time(-10, 0) );
        fail("Should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Hours value should be between 0 and 23"));
    }
}

shared void testAtInvalidMinute() {
    try {
        data_1982_12_13.at( time(10, 60) );
        fail("Should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Minutes value should be between 0 and 59"));
    }
}

shared void testAtInvalidSecond() {
    try {
        data_1982_12_13.at( time(10, 59, -1) );
        fail("Should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Seconds value should be between 0 and 59"));
    }
}

shared void testAtInvalidMillis() {
    try {
        data_1982_12_13.at( time(10, 59, 59, 1000) );
        fail("Should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Milliseconds value should be between 0 and 999"));
    }
}

shared void testPeriodFrom() {
    Period period = Period{ years = 2; months = 2; days = 3;};
    Date from = date(2011, october, 28);
    Date to = date(2013,december,31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromNegative() {
    Period period = Period{ years = -2; months = -2; days = -3;};
    Date to = date(2011, october, 28);
    Date from = date(2013,december,31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromOnlyDayChange() {
    Period period = Period{ days = 3;};
    Date from = date(2013, december, 28);
    Date to = date(2013,december,31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromOnlyDayChangeNegative() {
    Date to = date(2013, december, 28);
    Date from = date(2013,december,31);
    assertFromAndTo(Period{ days = -3;}, from, to);
}

shared void testPeriodFromNewYear() {
    Period period = Period{ days = 4; };
    Date from = date(2013, december, 28);
    Date to = date(2014,january,1);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromNewYearNegative() {
    Period period = Period{ days = -4; };
    Date from = date(2014,january,1);
    Date to = date(2013, december, 28);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromSameYear() {
    Period period = Period{ months = 8; days = 3;};
    Date from = date(2013, february,28);
    Date to = date(2013,october,31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromSameYearNegative() {
    Period period = Period{ months = -8; days = -3;};
    Date from = date(2013,october,31);
    Date to = date(2013, february,28);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromMonthBefore() {
    Period period = Period{ years = 1; months = 10; days = 3;}; 
    Date from = date(2011, december, 28);
    Date to = date(2013,october,31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromMonthBeforeNegative() {
    Period period = Period{ years = -1; months = -10; days = -3;}; 
    Date from = date(2013,october,31);
    Date to = date(2011, december, 28);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromOnlyMonthChange() {
    Period period = Period{ months = 2;};
    Date from = date(2013, january, 31);
    Date to = date(2013,march,31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromOnlyMonthChangeNegative() {
    Period period = Period{ months = -2;};
    Date from = date(2013,march,31);
    Date to = date(2013, january, 31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromOnlyYearChange() {
    Period period = Period{ years = 3;};
    Date from = date(2010, january, 31);
    Date to = date(2013,january,31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromOnlyYearChangeNegative() {
    Period period = Period{ years = -3;};
    Date from = date(2013,january,31);
    Date to = date(2010, january, 31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromYearMonthChange() {
    Period period = Period{ years = 1; months = 1;};
    Date from = date(2011, december, 31);
    Date to = date(2013,january,31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromYearMonthChangeNegative() {
    Period period = Period{ years = -1; months = -1;};
    Date from = date(2013,january,31);
    Date to = date(2011, december, 31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromLeapYear() {
    Period period = Period{ years = 1;};
    Date from = date(2012, february, 29);
    Date to = date(2013,february,28);
    assertEquals{
      expected = period;
      actual = to.periodFrom( from );
    };
    assertEquals{
      expected = period;
      actual = from.periodTo( to );
    };

    assertEquals(to, from.plus(period));
    assertEquals(from.minusDays(1), to.minus(period));
}

shared void testPeriodFromLeapYearNegative() {
    Period period = Period{ years = -1;};
    Date from = date(2013,february,28);
    Date to = date(2012, february, 28);
    assertEquals{
      expected = period;
      actual = to.periodFrom( from );
    };
    assertEquals{
      expected = period;
      actual = from.periodTo( to );
    };

    assertEquals(to, from.plus(period));
    assertEquals(from, to.minus(period));
}

shared void testPeriodFromDayAfter() {
    Period period = Period{ years = 2; days = 3;}; 
    Date from = date(2011, december, 28);
    Date to = date(2013,december,31);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromDayAfterNegative() {
    Period period = Period{ years = -2; days = -3;}; 
    Date from = date(2013,december,31);
    Date to = date(2011, december, 28);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromDayBefore() {
    Period period = Period{ years = 1; months = 11; days = 20;};
    Date from = date(2011, october, 30);
    Date to = date(2013,october,20);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromDayBeforeNegative() {
    Period period = Period{ years = -1; months = -11; days = -20;};
    Date from = date(2013,october,20);
    Date to = date(2011, october, 30);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromNegativeDay() {
    Period period = Period{ days = -1;};
    Date from = date(2011, october, 28);
    Date to = date(2011,october,27);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromEqualDate() {
    Period period = Period();
    Date from = date(2011, october, 30);
    Date to = date(2011, october, 30);
    assertFromAndTo(period, from, to);
}

shared void testPeriodFromAfterDate() {
    Date from = date(2011, december, 30);
    Date to = date(2011, october, 30);
    assertEquals{
      expected = Period { months = -2; };
      actual = to.periodFrom( from );
    };
    assertEquals{
      expected = Period { months = -2; };
      actual = from.periodTo( to );
    };
}

void assertFromAndTo( Period period, Date from, Date to ) {
    assertEquals{
      expected = period;
      actual = to.periodFrom( from );
    };
    assertEquals{
      expected = period;
      actual = from.periodTo( to );
    };

    assertEquals(to, from.plus(period));
    assertEquals(from, to.minus(period));
}

void assertAt(Integer year, Month month, Integer day, Integer h, Integer min, Integer sec, Integer ms ) {
    assertEquals( dateTime(year, month, day, h, min, sec, ms) , date(year, month, day).at( time(h, min, sec, ms) ));
}

// Asserts that what we put in, we get back from the Date object
void assertGregorianDate(Integer year, Month month, Integer day, DayOfWeek dayOfWeek, Boolean leapYear = false, Integer? dayOfYear = null ) {
    value actual = date(year, month, day);
    assertEquals(year, actual.year);
    assertEquals(month, actual.month);
    assertEquals(day, actual.day);
    assertEquals(dayOfWeek, actual.dayOfWeek);
    assertEquals(leapYear, actual.leapYear);

    if ( exists dayOfYear ) {
        assertEquals(dayOfYear, actual.dayOfYear);
    }
}

void assertException(String message, Integer year, Month month, Integer day) {
    try {
        date(year, month, day);
        fail("Expecting exception for invalid date: ``day``. ``month`` ``year``.");
    }
    catch ( AssertionException e ) {
        assertTrue(message.contains(message));
    }
}
