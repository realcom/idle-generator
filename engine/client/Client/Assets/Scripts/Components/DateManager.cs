using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

public static class DateManager
{
    // This presumes that weeks start with Monday.
    // Week 1 is the 1st week of the year with a Thursday in it.
    public static int GetIso8601WeekOfYear(DateTime time)
    {
        // Seriously cheat.  If its Monday, Tuesday or Wednesday, then it'll 
        // be the same week# as whatever Thursday, Friday or Saturday are,
        // and we always get those right
        DayOfWeek day = CultureInfo.InvariantCulture.Calendar.GetDayOfWeek(time);
        if (day >= DayOfWeek.Monday && day <= DayOfWeek.Wednesday)
        {
            time = time.AddDays(3);
        }

        // Return the week of our adjusted day
        return CultureInfo.InvariantCulture.Calendar.GetWeekOfYear(time, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday);
    }

    internal static int GetYearWeekInteger()
    {
        return GetYearWeekInteger(ZWorldClient.Get().serverDateTime);
    }

    internal static int GetYearMonthInteger()
    {
        return GetYearMonthInteger(ZWorldClient.Get().serverDateTime);
    }

    internal static int GetYearWeekInteger(DateTime now)
    {
        var week = GetIso8601WeekOfYear(now);
        if (now.Month == 1 && week > 50)
            return (now.Year - 1) * 100 + week;
        return now.Year * 100 + week;
    }

    internal static int GetYearMonthInteger(DateTime now)
    {
        return now.Year * 100 + now.Month;
    }

    internal static int GetDate(DateTime dt)
    {
        return dt.Year * 10000 + dt.Month * 100 + dt.Day;
    }

    internal static int GetTodayDate()
    {
        return GetDate(ZWorldClient.Get().serverDateTime);
    }

    public static DateTime StartOfWeek(this DateTime dt, DayOfWeek startOfWeek)
    {
        int diff = (7 + (dt.DayOfWeek - startOfWeek)) % 7;
        return dt.AddDays(-1 * diff).Date;
    }

    internal static int GetYesterdayDate()
    {
        var dt = ZWorldClient.Get().serverDateTime.AddDays(-1);
        return dt.Year * 1000 + dt.Month * 100 + dt.Day;
    }

}
