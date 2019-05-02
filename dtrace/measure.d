#!/usr/sbin/dtrace -s

#pragma D option quiet

ruby$target:::method-entry
{
  @method_call_count[copyinstr(arg0), copyinstr(arg1)] = count();
  self->method_starttime = walltimestamp / 1000;
}

ruby$target:::cmethod-entry
{
  @method_call_count[copyinstr(arg0), copyinstr(arg1)] = count();
  self->cmethod_starttime = walltimestamp / 1000;
}

ruby$target:::method-return
{
  @invoked_time[copyinstr(arg0), copyinstr(arg1)] = sum((walltimestamp / 1000) - self->method_starttime);
}

ruby$target:::cmethod-return
{
  @invoked_time[copyinstr(arg0), copyinstr(arg1)] = sum((walltimestamp / 1000) - self->cmethod_starttime);
}

END
{
    printf("\n");
    printf("%-30s  %-15s  %s\n", "CLASS", "METHOD", "COUNT");
    printf("--------------------------------------------------------------------------------\n");
    printa("%-30s  %-15s  %@d\n", @method_call_count);

    printf("\n");
    printf("%-30s  %-15s  %s\n", "CLASS", "METHOD", "TOTAL TIME usec");
    printf("--------------------------------------------------------------------------------\n");
    printa("%-30s  %-15s  %@d\n", @invoked_time);
}
