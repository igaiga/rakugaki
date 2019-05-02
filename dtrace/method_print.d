ruby$target:::method-entry
{
  printf("%s#%s\n", copyinstr(arg0), copyinstr(arg1));
}

ruby$target:::cmethod-entry
{
  printf("%s#%s\n", copyinstr(arg0), copyinstr(arg1));
}
