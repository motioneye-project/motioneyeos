#ifndef HAVE_DCGETTEXT
const char *dcgettext (const char *domain, const char *msg, int category)
{
  return msg;
}
#endif /* !HAVE_DCGETTEXT */
