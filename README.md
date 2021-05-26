### Damn I forgot my Meeting!

**Do you often miss your calendar events? Because you got distract? 1 minute late? Forgot to see the System notification?**

This repository provides a small script which will definitely remind you of your events!

---

### FAQ and Operation

**For which platforms this script works?**

This script was originally designed taking `macOS` in place because of the following dependencies

- The `say` command (not to be mistaken with GNU Say)
- How the `date` command operates differently
- Taking in place [iCalBuddy](https://hasseg.org/icalBuddy/) was installed via [Homebrew](https://brew.sh/)

**What are the dependencies?**

The `remind-me-please.sh` is a script made purely with Bash which requires the [iCalBuddy](https://hasseg.org/icalBuddy/) package.

You can easily install it by running

```shell
brew install ical-buddy
```

**How does the script works?**

- It will request iCalBuddy to give you the next Calendar entry from your day. (All-day events are ignored)
- If there's an entry the script will get the time of the event
- The script will compare if the event will happen in the next minute
- If all conditions above are met, the script will voice over your next Calendar entry
  - It will say something like "You have an upcoming meeting at TIME called Event Title"

**Note.:** The script executes in a `while` loop forever. It will execute the contents of the script every 1 minute. You can simply exit the script with `Ctrl + C`

**Script API**

This script contains a few arguments that you can use to customize it. The following is the usage of the script

```shell
remind-me-please.sh
  -d Enables Debug Mode | Default=FALSE
  -t 1|2|3|... The amount of minutes the script should consider as a matching time.
    Eg.: if you set it to m, if the event is at 16:00 and your current time is 15:58,
    then it will announce that the event is coming when it is 15:59.
    In other words this is how many minutes before the event starts that you want to be notified.
    Default=1
  -s How fast the voice should speak the reminder message | Default=150
  -v Which Voice model should be used.
     You can get a full list of voices by running `say -v "?"`
     Default="Samantha"
  -e Exclude some calendars. Give the Calendars name. | Default=""
```

**How to execute this script automatically on Startup** 

An easy way of making the Script to start on Boot it by running Automator. You can follow [this](https://stackoverflow.com/a/6445525) tutorial.

**Note.:** Crontabs are not supported.

**Can't execute the script?**

You need to give proper execution permissions to the script. Try running:

```shell
chmod a+x remind-me-please.sh
```

**How it reads my Calendar?**

- iCalBuddy uses the System Calendar Integration. Which means you need to have your Calendar imported on the macOS Calendar App.
It can be a CalDav, iCal or even Internet Account.
- On the first execution, if you're using macOS Catalina or later, it will request Calendar and Documents permission, since `iCalBuddy` requires it for reading your calendar.
- No OAuth permission or any grant permission is needed.

**Note.:** It will by default read data from all your Calendars.

**Why you made this script?**

- I don't want to connect calendar on Alexa, or other Speaker devices that announce Calendar entries
- Can be executed in any macOS running computer (Potentially Linux too with some modifications)
- Doesn't require Login, Authentication or anything like that.
