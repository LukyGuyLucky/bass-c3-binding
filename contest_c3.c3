/*  Converted to c3 from below:
	BASS simple console player
	Copyright (c) 1999-2022 Un4seen Developments Ltd.
    
    use at your own risk.
*/
module contest_c3;
import bass;
import libc;
import std::thread;
import std::time;

macro sleep(x) => thread::sleep_ms(x);


/*
fn int _kbhit()
{
	int r;
	fd_set rfds;
	struct timeval tv = { 0 };
	struct termios term, oterm;
	tcgetattr(0, &oterm);
	memcpy(&term, &oterm, sizeof(term));
	cfmakeraw(&term);
	tcsetattr(0, TCSANOW, &term);
	FD_ZERO(&rfds);
	FD_SET(0, &rfds);
	r = select(1, &rfds, NULL, NULL, &tv);
	tcsetattr(0, TCSANOW, &oterm);
	return r;
}
*/

// display error messages
fn void error(ZString text)
{
	libc::printf("Error(%d): %s\n", bass::errorGetCode(), text);
	bass::free();
	libc::exit(0);
}

fn void listDevices()
{
	Bass_DeviceInfo di;//BASS_DEVICEINFO di;
	int a;
	for (a = 0; bass::getDeviceInfo(a, &di); a++) {
		if (di.flags & bass::DEVICE_ENABLED) // enabled output device
        {
			libc::printf("dev %d: %s\n", a, di.name);
        }
	}
}

fn int main(String[] args)
{
	uint chan, act, level;
	long pos;
	double secs;
	int a, filep;
    int device = -1;
	Bass_ChannelInfo info;//BASS_CHANNELINFO info;

	libc::printf("BASS simple console player\n"
		"--------------------------\n");

	// check the correct BASS was loaded
	if (bass::hiword(bass::getVersion()) != bass::BASSVERSION) {
		libc::printf("An incorrect version of BASS was loaded");
		return 0;
	}

	for (filep = 1; filep < args.len; filep++) {
		if (!libc::strcmp((ZString)args[filep], "-l")) {
			listDevices();
			return 0;
		} else if (!libc::strcmp((ZString)args[filep], "-d") && filep + 1 < args.len)
        {
			device = libc::atoi(args[++filep]);
        }
		else
        {
			break;
        }
	}
	if (filep == args.len) {
		libc::printf("\tusage: contest [-l] [-d #] <file>\n"
			"\t-l = list devices\n"
			"\t-d = device number\n");
		return 0;
	}

	bass::setConfig(bass::CONFIG_NET_PLAYLIST, 2); // enable playlist processing

	// initialize output device
	if (!bass::init(device, 48000, 0, null, null))
    {   
        error("Can't initialize device");
    }

	if (libc::strstr((ZString)args[filep], "://")) {
		// try streaming the URL
		chan = bass::streamCreateURLW(args[filep].to_temp_wstring()/*(WString)args[filep].ptr*/,0, bass::SAMPLE_LOOP | bass::SAMPLE_FLOAT, null,null)!!;
	} else {
		// try streaming the file
		chan = bass::streamCreateFileW(false, args[filep].to_temp_wstring(), 0, 0, bass::SAMPLE_LOOP | bass::SAMPLE_FLOAT)!!;
		if (!chan && bass::errorGetCode() == bass::ERROR_FILEFORM) {
			// try MOD music formats
			chan = bass::musicLoadW(false, args[filep].to_temp_wstring(), 0, 0, bass::SAMPLE_LOOP | bass::SAMPLE_FLOAT | bass::MUSIC_RAMPS | bass::MUSIC_PRESCAN, 1)!!;
		}
	}
	if (!chan) {error("Can't play the file");}

	bass::channelGetInfo(chan, &info);
	libc::printf("ctype: %x\n", info.ctype);
	if (bass::hiword(info.ctype) != 2) {
		if (info.origres)
        {
            libc::printf("format: %u Hz, %d chan, %d bit\n", info.freq, info.chans, bass::loword(info.origres));
        }
		else
        {
			libc::printf("format: %u Hz, %d chan\n", info.freq, info.chans);
        }
	}
	pos = bass::channelGetLength(chan, bass::POS_BYTE);
	if (pos != -1) {
		secs = bass::channelBytes2Seconds(chan, pos);
		if (bass::hiword(info.ctype) == 2)
        {
			libc::printf("length: %u:%02u (%llu samples), %u orders\n", (int)secs / 60, (int)secs % 60, (long)(secs * info.freq), (uint)bass::channelGetLength(chan, bass::POS_MUSIC_ORDER));
        }
		else
		{
			libc::printf("length: %u:%02u (%llu samples)\n", (int)secs / 60, (int)secs % 60, (long)(secs * info.freq));
		}
	} else if (bass::hiword(info.ctype) == 2)
		{
			libc::printf("length: %u orders\n", (uint)bass::channelGetLength(chan, bass::POS_MUSIC_ORDER));
		}

	bass::channelPlay(chan, false);

	while (libc::getchar()!='p' && (act = bass::channelIsActive(chan))) {
		// display some stuff and wait a bit
        
      
		level = bass::channelGetLevel(chan);
		pos = bass::channelGetPosition(chan, bass::POS_BYTE);
		secs = bass::channelBytes2Seconds(chan, pos);
		libc::printf(" %u:%02u (%08lld)", (int)secs / 60, (int)secs % 60, (long)(secs * info.freq));
		if (bass::hiword(info.ctype) == 2) {
			pos = bass::channelGetPosition(chan, bass::POS_MUSIC_ORDER);
			libc::printf(" | %03u:%03u", bass::loword(pos), bass::hiword(pos));
		}
		libc::printf(" | L ");
		if (act == bass::ACTIVE_STALLED) { // playback has stalled
			libc::printf("-     buffering: %3u%%     -", 100 - (uint)bass::streamGetFilePosition(chan, bass::FILEPOS_BUFFERING));
		} else {
			for (a = 27204; a > 200; a = a * 2 / 3) {libc::putchar(bass::loword(level) >= a ? '*' : '-');}
			libc::putchar(' ');
			for (a = 210; a < 32768; a = a * 3 / 2) {libc::putchar(bass::hiword(level) >= a ? '*' : '-');}
		}
		libc::printf(" R | cpu %.2f%%  \r", bass::getCPU());
		libc::fflush(libc::stdout());
		sleep(50)!!;
		
	}
	
	bass::free();
	
	libc::printf("<-----------------------------> \n");
	
	return 0;
}
