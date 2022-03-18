# Fighting spam on this site

It's an unfortunate reality that there seem to be millions of people
around the world who are busy inserting nonsense into email and public
web sites / forums such as this. The stuff they post are complete
nonsense and don't seem to do anything. Yet we spend precious time on
fighting this nonsense, distracting us from real work.

1.  Initially this site was open. Soon we got spam on tickets and wiki.
2.  We require users to sign up before they can post.
3.  Then we had the spammers sign up first.
4.  Then we added CAPTCHA to sign up.
5.  Then the spammers manually cracked them and spammed anyway.

Now we will take away the incentive for spamming by removing the
Timeline and the Reports from unauthenticated users.

Ideally we would hide non-reviewed tickets from the Timeline and the
Reports for the public, but Trac does not have that feature.

UPDATE (August 2015) some 4 years later: the level of SPAM has fallen to
effectively zero. The most effective method was not to display Timeline
and ticket data to users who are not signed in. So, this fight spam
project is complete.

UPDATE (February 2018) some 3 years later: there is still some spammer
activity, although by far not at the same rate as before. It is easy to
forget the exact SOP for spam tickets.

I now do the following:

1.  click on Modify Ticket,
2.  close the ticket as "spam"
3.  replace the short description line with the tag "\[SPAM\]"
4.  replace the entire text with the tag "\[SPAM\]"

I had some automated process at some point in the past, which listed
spammers with an sql query and marked them as spammers and/or removed
the user entries from the htdigest file. This may need to be verified
and documented. We could potentially record the IP addresses and block
them from spammers.
