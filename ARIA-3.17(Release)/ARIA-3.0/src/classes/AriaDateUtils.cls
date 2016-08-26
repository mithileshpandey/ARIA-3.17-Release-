public with sharing class AriaDateUtils {

    private static Date gregorianStart = Date.newInstance( 1582, 10, 15 ); // Gregorian calendar begins

    class DateException extends Exception{}

    // finds the day of week using Babwani's Congruence
    // http://en.wikipedia.org/wiki/Calculating_the_day_of_the_week
    // currently only works for Gregorian dates but easy to do Julian following Babwani's paper
    // returns 1-7 for Sunday - Saturday

    public static integer dayOfWeek( Date d ) {

        if( AriaDateUtils.gregorianStart.daysBetween( d ) < 0 ) {
            throw new DateException ( 'The dayOfWeek function currently only works for Gregorian-era dates, on or after 10/15/1582');
        }

        Integer y = d.year();
        Integer m = d.month();
        Integer day = d.day();
        // is it a leap year?
        Integer l = ( Math.mod( y, 100 ) == 0 && Math.mod(y,400) != 0) ? 0: ( ( Math.mod( y, 4) == 0 ) ? 1 : 0 );
        Integer cent = y / 100;
        Double dm = 1.0 * m;
        Double fm = Math.floor( 3 + ( 2 * Math.floor( 0.5 + ( 1 / dm ) ) ) + ( 5 * dm + Math.floor( dm / 9 ) ) / 2 ) - l * Math.floor( 0.5 + ( 1 / dm ) );
        Integer yy = y - (cent * 100 );
        Double day_n= Math.floor( 1.25 * yy ) + fm + day - 2 * Math.mod( cent, 4 );
        Integer dayInt = day_n.intValue();
        Integer dayRem = Math.mod( dayInt, 7 );
        // System.debug( 'L = ' + l + ' Cent = ' + cent + ' fm = ' + fm + ' yy = ' + yy + ' day_n = ' + day_n + ' dayRem = ' + dayRem );
        return dayRem == 0 ? 7 : dayRem;
    }

    public static integer daysOverlap ( Date p1Start, Date p1End, Date p2Start, Date p2End ) {
        // System.debug( 'p1Start = ' + p1Start + 'p1End = ' + p1End + 'p2Start = ' + p2Start + 'p2End = ' + p2End );
        if ( null == p1Start || null == p1End || null == p2Start || null == p2End ) {
            throw new DateException ( 'One or more supplied date ranges is invalid.' );
        }
        if ( p1Start.daysBetween( p1End ) < 0 || p2Start.daysBetween( p2End ) < 0 ) {
            throw new DateException ( 'One or more supplied date ranges is invalid.' );
        }
        if( p1Start > p2End || p1End < p2Start ) { return 0; }         // ranges do not overlap, bail
        Date overlapStart = p1Start < p2Start ? p2Start : p1Start;   // no native Max function for dates
        Date overlapEnd = p1End < p2End ? p1End : p2End;              // nor Min neither ...
        return overlapStart.daysBetween( overlapEnd ) + 1; // daysBetween gives 1 less than what we want

    }

    /* these date formatting functions use formatting strings borrowed from Postgres:
       http://www.postgresql.org/docs/8.3/interactive/functions-formatting.html
       Not all are presently supported -- feel free to add unsupported ones
       */

    public static String formatDate( Date theDate, String formatString ) {
        Datetime dt = Datetime.newInstance( theDate.year(), theDate.month(), theDate.day(), 0, 0, 0 );
        return AriaDateUtils.formatDateTime( dt, formatString );
    }

    public static String formatDateTime( Datetime dt, String formatString ) {

        String yr = String.valueOf( dt.year() );
        String month = String.valueOf( dt.month() );
        String day = String.valueOf( dt.day() );
        String hour = String.valueOf( dt.hour() );
        String min = String.valueOf( dt.minute() );
        String sec = String.valueOf( dt.second() );
        String ms = String.valueOf( dt.millisecond() );

        formatString = formatString.replace( 'YYYY', String.valueOf( yr ) );
        formatString = formatString.replace( 'YYY', yr.substring( yr.length() - 3 ) );
        formatString = formatString.replace( 'YY', yr.substring( yr.length() - 2 ) );
        formatString = formatString.replace( 'Y', yr.substring( yr.length() - 1 ) );

        formatString = formatString.replace( 'MM', AriaStringUtils.padLeft( month, '0', 2 ) );

        formatString = formatString.replace( 'DD', AriaStringUtils.padLeft( day, '0', 2 ) );

        formatString = formatString.replace( 'HH', AriaStringUtils.padLeft( hour, '0', 2 ) );

        formatString = formatString.replace( 'MI', AriaStringUtils.padLeft( min, '0', 2 ) );

        formatString = formatString.replace( 'SS', AriaStringUtils.padLeft( sec, '0', 2 ) );

        formatString = formatString.replace( 'MS', AriaStringUtils.padLeft( ms, '0', 3 ) );

        return formatString;
    }

   
}