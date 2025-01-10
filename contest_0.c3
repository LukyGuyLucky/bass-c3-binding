/*  Converted to c3 from below:
	BASS simple console player
	Copyright (c) 1999-2022 Un4seen Developments Ltd.
    
    use at your own risk.
*/

module contest_0;

import libc;
import std::thread;
import std::time;


macro sleep(x) => thread::sleep_ms(x);

// display error messages
fn void error(ZString text)
{
	libc::printf("Error(%d): %s\n", bass_errorGetCode(), text);
	bass_free();
	libc::exit(0);
}

fn void listDevices()
{
	Bass_DeviceInfo di;//BASS_DEVICEINFO di;
	int a;
	for (a = 0; bass_getDeviceInfo(a, &di); a++) {
		if (di.flags & BASS_DEVICE_ENABLED) // enabled output device
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
	if (hiword(bass_getVersion()) != BASSVERSION) {
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

	bass_setConfig(BASS_CONFIG_NET_PLAYLIST, 2); // enable playlist processing

	// initialize output device
	if (!bass_init(device, 48000, 0, null, null))
    {   
        error("Can't initialize device");
    }

	if (libc::strstr((ZString)args[filep], "://")) {
		// try streaming the URL
		chan = bass_streamCreateURL((ZString)args[filep], 0, BASS_SAMPLE_LOOP | BASS_SAMPLE_FLOAT, null,null);
	} else {
		// try streaming the file
		chan = bass_streamCreateFile(false, args[filep], 0, 0, BASS_SAMPLE_LOOP | BASS_SAMPLE_FLOAT);
		if (!chan && bass_errorGetCode() == BASS_ERROR_FILEFORM) {
			// try MOD music formats
			chan = bass_music_load(false, (WString)args[filep].ptr, 0, 0, BASS_SAMPLE_LOOP | BASS_SAMPLE_FLOAT | BASS_MUSIC_RAMPS | BASS_MUSIC_PRESCAN, 1);
		}
	}
	if (!chan) {error("Can't play the file");}

	bass_channelGetInfo(chan, &info);
	libc::printf("ctype: %x\n", info.ctype);
	if (hiword(info.ctype) != 2) {
		if (info.origres)
        {
            libc::printf("format: %u Hz, %d chan, %d bit\n", info.freq, info.chans, loword(info.origres));
        }
		else
        {
			libc::printf("format: %u Hz, %d chan\n", info.freq, info.chans);
        }
	}
	pos = bass_channelGetLength(chan, BASS_POS_BYTE);
	if (pos != -1) {
		secs = bass_channelBytes2Seconds(chan, pos);
		if (hiword(info.ctype) == 2)
        {
			libc::printf("length: %u:%02u (%llu samples), %u orders\n", (int)secs / 60, (int)secs % 60, (long)(secs * info.freq), (uint)bass_channelGetLength(chan, BASS_POS_MUSIC_ORDER));
        }
		else
		{
            libc::printf("length: %u:%02u (%llu samples)\n", (int)secs / 60, (int)secs % 60, (long)(secs * info.freq));
        }
	} else if (hiword(info.ctype) == 2)
    {
		libc::printf("length: %u orders\n", (uint)bass_channelGetLength(chan, BASS_POS_MUSIC_ORDER));
    }

	bass_channelPlay(chan, false);

	while (true && (act = bass_channelIsActive(chan))) {
		// display some stuff and wait a bit
        
        if(libc::getchar()=='p')
        {
            break;
        }
		level = bass_channelGetLevel(chan);
		pos = bass_channelGetPosition(chan, BASS_POS_BYTE);
		secs = bass_channelBytes2Seconds(chan, pos);
		libc::printf(" %u:%02u (%08lld)", (int)secs / 60, (int)secs % 60, (long)(secs * info.freq));
		if (hiword(info.ctype) == 2) {
			pos = bass_channelGetPosition(chan, BASS_POS_MUSIC_ORDER);
			libc::printf(" | %03u:%03u", loword(pos), hiword(pos));
		}
		libc::printf(" | L ");
		if (act == BASS_ACTIVE_STALLED) { // playback has stalled
			libc::printf("-     buffering: %3u%%     -", 100 - (uint)bass_streamGetFilePosition(chan, BASS_FILEPOS_BUFFERING));
		} else {
			for (a = 27204; a > 200; a = a * 2 / 3) {libc::putchar(loword(level) >= a ? '*' : '-');}
			libc::putchar(' ');
			for (a = 210; a < 32768; a = a * 3 / 2) {libc::putchar(hiword(level) >= a ? '*' : '-');}
		}
		libc::printf(" R | cpu %.2f%%  \r", bass_getCPU());
		libc::fflush(libc::stdout());
		sleep(50)!!;
	}
	libc::printf("<-----------------------------> \n");

	bass_free();
	return 0;
}


/* bass.h -> bass.c3 bindings keeping the original naming style */

macro lobyte(a)=>(char)(a);//LOBYTE(a) (BYTE)(a)
macro hibyte(a) =>(char)(a>>8);//const HIBYTE(a) (BYTE)((a)>>8)
macro loword(a) => (uint)(a);//const LOWORD(a) (WORD)(a)
macro hiword(a)=>(uint)(a>>16);//const HIWORD(a) (WORD)((a)>>16)
macro makeword(a,b)=>(uint)(a&0xff || b<<8);//const MAKEWORD(a,b) (WORD)(((a)&0xff)|((b)<<8))
macro makelong(a,b) => (ulong)(a & 0xffff || b<<16);//const MAKELONG(a,b) (DWORD)(((a)&0xffff)|((b)<<16))

const BASSVERSION	=		0x204;	// API version
const BASSVERSIONTEXT	=	"2.4";


/*
typedef DWORD HMUSIC;		// MOD music handle
typedef DWORD HSAMPLE;		// sample handle
typedef DWORD HCHANNEL;		// sample playback handle
typedef DWORD HSTREAM;		// sample stream handle
typedef DWORD HRECORD;		// recording handle
typedef DWORD HSYNC;		// synchronizer handle
typedef DWORD HDSP;			// DSP handle
typedef DWORD HFX;			// effect handle
typedef DWORD HPLUGIN;		// plugin handle
*/


// Error codes returned by BASS_ErrorGetCode
const BASS_OK				=0;	// all is OK
const BASS_ERROR_MEM		=1;	// memory error
const BASS_ERROR_FILEOPEN	=2;	// can't open the file
const BASS_ERROR_DRIVER	=3;	// can't find a free/valid driver
const BASS_ERROR_BUFLOST	=4;	// the sample buffer was lost
const BASS_ERROR_HANDLE	=5;	// invalid handle
const BASS_ERROR_FORMAT	=6;	// unsupported sample format
const BASS_ERROR_POSITION	=7;	// invalid position
const BASS_ERROR_INIT		=8;	// BASS_Init has not been successfully called
const BASS_ERROR_START	=9;	// BASS_Start has not been successfully called
const BASS_ERROR_SSL		=10;	// SSL/HTTPS support isn't available
const BASS_ERROR_REINIT	=11;	// device needs to be reinitialized
const BASS_ERROR_ALREADY	=14;	// already initialized/paused/whatever
const BASS_ERROR_NOTAUDIO	=17;	// file does not contain audio
const BASS_ERROR_NOCHAN	=18;	// can't get a free channel
const BASS_ERROR_ILLTYPE	=19;	// an illegal type was specified
const BASS_ERROR_ILLPARAM	=20;	// an illegal parameter was specified
const BASS_ERROR_NO3D		=21;	// no 3D support
const BASS_ERROR_NOEAX	=22;	// no EAX support
const BASS_ERROR_DEVICE	=23;	// illegal device number
const BASS_ERROR_NOPLAY	=24;	// not playing
const BASS_ERROR_FREQ		=25;	// illegal sample rate
const BASS_ERROR_NOTFILE	=27	;// the stream is not a file stream
const BASS_ERROR_NOHW		=29;	// no hardware voices available
const BASS_ERROR_EMPTY	=31;	// the file has no sample data
const BASS_ERROR_NONET	=32;	// no internet connection could be opened
const BASS_ERROR_CREATE	=33;	// couldn't create the file
const BASS_ERROR_NOFX		=34;	// effects are not available
const BASS_ERROR_NOTAVAIL	=37;	// requested data/action is not available
const BASS_ERROR_DECODE	=38;	// the channel is/isn't a "decoding channel"
const BASS_ERROR_DX		=39;	// a sufficient DirectX version is not installed
const BASS_ERROR_TIMEOUT	=40;	// connection timedout
const BASS_ERROR_FILEFORM	=41	;// unsupported file format
const BASS_ERROR_SPEAKER	=42;	// unavailable speaker
const BASS_ERROR_VERSION	=43;	// invalid BASS version (used by add-ons)
const BASS_ERROR_CODEC	=44;	// codec is not available/supported
const BASS_ERROR_ENDED	=45;	// the channel/file has ended
const BASS_ERROR_BUSY		=46;	// the device is busy
const BASS_ERROR_UNSTREAMABLE	=47;	// unstreamable file
const BASS_ERROR_PROTOCOL	=48;	// unsupported protocol
const BASS_ERROR_DENIED	=49;	// access denied
const BASS_ERROR_UNKNOWN	=-1;	// some other mystery problem

// BASS_SetConfig options
const BASS_CONFIG_BUFFER			=0;
const BASS_CONFIG_UPDATEPERIOD	=1;
const BASS_CONFIG_GVOL_SAMPLE		=4;
const BASS_CONFIG_GVOL_STREAM		=5;
const BASS_CONFIG_GVOL_MUSIC		=6;
const BASS_CONFIG_CURVE_VOL		=7;
const BASS_CONFIG_CURVE_PAN		=8;
const BASS_CONFIG_FLOATDSP		=9;
const BASS_CONFIG_3DALGORITHM		=10;
const BASS_CONFIG_NET_TIMEOUT		=11;
const BASS_CONFIG_NET_BUFFER		=12;
const BASS_CONFIG_PAUSE_NOPLAY	=13;
const BASS_CONFIG_NET_PREBUF		=15;
const BASS_CONFIG_NET_PASSIVE		=18;
const BASS_CONFIG_REC_BUFFER		=19;
const BASS_CONFIG_NET_PLAYLIST	=21;
const BASS_CONFIG_MUSIC_VIRTUAL	=22;
const BASS_CONFIG_VERIFY			=23;
const BASS_CONFIG_UPDATETHREADS	=24;
const BASS_CONFIG_DEV_BUFFER		=27;
const BASS_CONFIG_REC_LOOPBACK	=28;
const BASS_CONFIG_VISTA_TRUEPOS	=30;
const BASS_CONFIG_IOS_SESSION		=34;
const BASS_CONFIG_IOS_MIXAUDIO	=34;
const BASS_CONFIG_DEV_DEFAULT		=36;
const BASS_CONFIG_NET_READTIMEOUT	=37;
const BASS_CONFIG_VISTA_SPEAKERS	=38;
const BASS_CONFIG_IOS_SPEAKER		=39;
const BASS_CONFIG_MF_DISABLE		=40;
const BASS_CONFIG_UNICODE			=42;
const BASS_CONFIG_SRC_SAMPLE		=44;
const BASS_CONFIG_ASYNCFILE_BUFFER =45;
const BASS_CONFIG_OGG_PRESCAN		=47;
const BASS_CONFIG_MF_VIDEO		=48;
const BASS_CONFIG_AIRPLAY			=49;
const BASS_CONFIG_DEV_NONSTOP		=50;
const BASS_CONFIG_VERIFY_NET		=52;
const BASS_CONFIG_DEV_PERIOD		=53;
const BASS_CONFIG_FLOAT			=54;
const BASS_CONFIG_NET_SEEK		=56;
const BASS_CONFIG_AM_DISABLE		=58;
const BASS_CONFIG_NET_PLAYLIST_DEPTH	=59;
const BASS_CONFIG_NET_PREBUF_WAIT	=60;
const BASS_CONFIG_ANDROID_SESSIONID	=62;
const BASS_CONFIG_WASAPI_PERSIST	=65;
const BASS_CONFIG_ANDROID_AAUDIO	=67;
const BASS_CONFIG_SAMPLE_ONEHANDLE	=69;
const BASS_CONFIG_NET_META		=71;
const BASS_CONFIG_NET_RESTRATE	=72;
const BASS_CONFIG_REC_DEFAULT		=73;
const BASS_CONFIG_NORAMP			=74;

// BASS_SetConfigPtr options
const BASS_CONFIG_NET_AGENT		=16;
const BASS_CONFIG_NET_PROXY		=17;
const BASS_CONFIG_IOS_NOTIFY		=46;
const BASS_CONFIG_ANDROID_JAVAVM	=63;
const BASS_CONFIG_LIBSSL			=64;
const BASS_CONFIG_FILENAME		=75;

const BASS_CONFIG_THREAD			=0x40000000 ;// flag: thread-specific setting

// BASS_CONFIG_IOS_SESSION flags
const BASS_IOS_SESSION_MIX		=1;
const BASS_IOS_SESSION_DUCK		=2;
const BASS_IOS_SESSION_AMBIENT	=4;
const BASS_IOS_SESSION_SPEAKER	=8;
const BASS_IOS_SESSION_DISABLE	=16;
const BASS_IOS_SESSION_DEACTIVATE	=32;
const BASS_IOS_SESSION_AIRPLAY	=64;
const BASS_IOS_SESSION_BTHFP		=128;
const BASS_IOS_SESSION_BTA2DP		=0x100;

// BASS_Init flags
const BASS_DEVICE_8BITS		=1	;	// unused
const BASS_DEVICE_MONO		=2	;	// mono
const BASS_DEVICE_3D			=4	;	// unused
const BASS_DEVICE_16BITS		=8	;	// limit output to 16-bit
const BASS_DEVICE_REINIT		=128;		// reinitialize
const BASS_DEVICE_LATENCY		=0x100	;// unused
const BASS_DEVICE_CPSPEAKERS	=0x400;	// unused
const BASS_DEVICE_SPEAKERS	=0x800	;// force enabling of speaker assignment
const BASS_DEVICE_NOSPEAKER	=0x1000	;// ignore speaker arrangement
const BASS_DEVICE_DMIX		=0x2000	;// use ALSA "dmix" plugin
const BASS_DEVICE_FREQ		=0x4000	;// set device sample rate
const BASS_DEVICE_STEREO		=0x8000	;// limit output to stereo
const BASS_DEVICE_HOG			=0x10000;	// hog/exclusive mode
const BASS_DEVICE_AUDIOTRACK	=0x20000;	// use AudioTrack output
const BASS_DEVICE_DSOUND		=0x40000;	// use DirectSound output
const BASS_DEVICE_SOFTWARE	=0x80000;	// disable hardware/fastpath output

// DirectSound interfaces (for use with BASS_GetDSoundObject)
const BASS_OBJECT_DS		=1;	// IDirectSound
const BASS_OBJECT_DS3DL	=2	;// IDirectSound3DListener

// Device info structure
struct Bass_DeviceInfo{

	ZString name;	// description
	ZString driver;	// driver

	uint flags;
} 


// BASS_DEVICEINFO flags
const BASS_DEVICE_ENABLED	=1;
const BASS_DEVICE_DEFAULT		=2;
const BASS_DEVICE_INIT		=4;
const BASS_DEVICE_LOOPBACK	=8;
const BASS_DEVICE_DEFAULTCOM	=128;

const BASS_DEVICE_TYPE_MASK			=0xff000000;
const BASS_DEVICE_TYPE_NETWORK		=0x01000000;
const BASS_DEVICE_TYPE_SPEAKERS		=0x02000000;
const BASS_DEVICE_TYPE_LINE			=0x03000000;
const BASS_DEVICE_TYPE_HEADPHONES		=0x04000000;
const BASS_DEVICE_TYPE_MICROPHONE		=0x05000000;
const BASS_DEVICE_TYPE_HEADSET		=0x06000000;
const BASS_DEVICE_TYPE_HANDSET		=0x07000000;
const BASS_DEVICE_TYPE_DIGITAL		=0x08000000;
const BASS_DEVICE_TYPE_SPDIF			=0x09000000;
const BASS_DEVICE_TYPE_HDMI			=0x0a000000;
const BASS_DEVICE_TYPE_DISPLAYPORT	=0x40000000;

// BASS_GetDeviceInfo flags
const BASS_DEVICES_AIRPLAY	=0x1000000;

struct Bass_Info{
	uint flags;	// device capabilities (DSCAPS_xxx flags)
	uint hwsize;	// unused
	uint hwfree;	// unused
	uint freesam;	// unused
	uint free3d;	// unused
	uint minrate;	// unused
	uint maxrate;	// unused
	bool eax;		// unused
	uint minbuf;	// recommended minimum buffer length in ms
	uint dsver;	// DirectSound version
	uint latency;	// average delay (in ms) before start of playback
	uint initflags; // BASS_Init "flags" parameter
	uint speakers; // number of speakers available
	uint freq;		// current output rate
} 


// BASS_INFO flags (from DSOUND.H)
const DSCAPS_EMULDRIVER		=0x00000020	;// device does not have hardware DirectSound support
const DSCAPS_CERTIFIED		=0x00000040	;// device driver has been certified by Microsoft

const DSCAPS_HARDWARE			=0x80000000;	// hardware mixed

// Recording device info structure
struct Bass_RecordInfo{
	uint flags;	// device capabilities (DSCCAPS_xxx flags)
	uint formats;	// supported standard formats (WAVE_FORMAT_xxx flags)
	uint inputs;	// number of inputs
	bool singlein;	// TRUE = only 1 input can be set at a time
	uint freq;		// current input rate
} 


// BASS_RECORDINFO flags (from DSOUND.H)
const DSCCAPS_EMULDRIVER	=DSCAPS_EMULDRIVER;	// device does not have hardware DirectSound recording support
const DSCCAPS_CERTIFIED	=DSCAPS_CERTIFIED;	// device driver has been certified by Microsoft

// defines for formats field of BASS_RECORDINFO (from MMSYSTEM.H)
//#ifndef WAVE_FORMAT_1M08

const WAVE_FORMAT_1M08       =0x00000001  ;     /* 11.025 kHz, Mono,   8-bit  */
const WAVE_FORMAT_1S08       =0x00000002 ;     /* 11.025 kHz, Stereo, 8-bit  */
const WAVE_FORMAT_1M16       =0x00000004 ;      /* 11.025 kHz, Mono,   16-bit */
const WAVE_FORMAT_1S16       =0x00000008 ;      /* 11.025 kHz, Stereo, 16-bit */
const WAVE_FORMAT_2M08       =0x00000010 ;      /* 22.05  kHz, Mono,   8-bit  */
const WAVE_FORMAT_2S08       =0x00000020 ;      /* 22.05  kHz, Stereo, 8-bit  */
const WAVE_FORMAT_2M16       =0x00000040  ;     /* 22.05  kHz, Mono,   16-bit */
const WAVE_FORMAT_2S16       =0x00000080  ;     /* 22.05  kHz, Stereo, 16-bit */
const WAVE_FORMAT_4M08       =0x00000100 ;      /* 44.1   kHz, Mono,   8-bit  */
const WAVE_FORMAT_4S08      = 0x00000200  ;     /* 44.1   kHz, Stereo, 8-bit  */
const WAVE_FORMAT_4M16       =0x00000400   ;    /* 44.1   kHz, Mono,   16-bit */
const WAVE_FORMAT_4S16      = 0x00000800  ;     /* 44.1   kHz, Stereo, 16-bit */



// Sample info structure
struct Bass_Sample{
	uint freq;		// default playback rate
	float volume;	// default volume (0-1)
	float pan;		// default pan (-1=left, 0=middle, 1=right)
	uint flags;	// BASS_SAMPLE_xxx flags
	uint length;	// length (in bytes)
	uint max;		// maximum simultaneous playbacks
	uint origres;	// original resolution
	uint chans;	// number of channels
	uint mingap;	// minimum gap (ms) between creating channels
	uint mode3d;	// BASS_3DMODE_xxx mode
	float mindist;	// minimum distance
	float maxdist;	// maximum distance
	uint iangle;	// angle of inside projection cone
	uint oangle;	// angle of outside projection cone
	float outvol;	// delta-volume outside the projection cone
	uint vam;		// unused
	uint priority;	// unused
}


const BASS_SAMPLE_8BITS		=1	;// 8 bit
const BASS_SAMPLE_FLOAT		=256;	// 32 bit floating-point
const BASS_SAMPLE_MONO		=2	;// mono
const BASS_SAMPLE_LOOP		=4	;// looped
const BASS_SAMPLE_3D			=8;	// 3D functionality
const BASS_SAMPLE_SOFTWARE	=16	;// unused
const BASS_SAMPLE_MUTEMAX		=32	;// mute at max distance (3D only)
const BASS_SAMPLE_VAM			=64	;// unused
const BASS_SAMPLE_FX			=128;	// unused
const BASS_SAMPLE_OVER_VOL	=0x10000;	// override lowest volume
const BASS_SAMPLE_OVER_POS	=0x20000;	// override longest playing
const BASS_SAMPLE_OVER_DIST	=0x30000; // override furthest from listener (3D only)

const BASS_STREAM_PRESCAN		=0x20000 ;// scan file for accurate seeking and length
const BASS_STREAM_AUTOFREE	=0x40000;	// automatically free the stream when it stops/ends
const BASS_STREAM_RESTRATE	=0x80000;	// restrict the download rate of internet file stream
const BASS_STREAM_BLOCK		=0x100000; // download internet file stream in small blocks
const BASS_STREAM_DECODE		=0x200000 ;// don't play the stream, only decode
const BASS_STREAM_STATUS		=0x800000; // give server status info (HTTP/ICY tags) in DOWNLOADPROC

const BASS_MP3_IGNOREDELAY	=0x200; // ignore LAME/Xing/VBRI/iTunes delay & padding info
const BASS_MP3_SETPOS			=BASS_STREAM_PRESCAN;

const BASS_MUSIC_FLOAT		=BASS_SAMPLE_FLOAT;
const BASS_MUSIC_MONO			=BASS_SAMPLE_MONO;
const BASS_MUSIC_LOOP			=BASS_SAMPLE_LOOP;
const BASS_MUSIC_3D			=BASS_SAMPLE_3D;
const BASS_MUSIC_FX			=BASS_SAMPLE_FX;
const BASS_MUSIC_AUTOFREE		=BASS_STREAM_AUTOFREE;
const BASS_MUSIC_DECODE		=BASS_STREAM_DECODE;
const BASS_MUSIC_PRESCAN		=BASS_STREAM_PRESCAN;	// calculate playback length
const BASS_MUSIC_CALCLEN		=BASS_MUSIC_PRESCAN;
const BASS_MUSIC_RAMP			=0x200;	// normal ramping
const BASS_MUSIC_RAMPS		=0x400;	// sensitive ramping
const BASS_MUSIC_SURROUND		=0x800;	// surround sound
const BASS_MUSIC_SURROUND2	=0x1000;	// surround sound (mode 2)
const BASS_MUSIC_FT2PAN		=0x2000	;// apply FastTracker 2 panning to XM files
const BASS_MUSIC_FT2MOD		=0x2000;	// play .MOD as FastTracker 2 does
const BASS_MUSIC_PT1MOD		=0x4000	;// play .MOD as ProTracker 1 does
const BASS_MUSIC_NONINTER		=0x10000;	// non-interpolated sample mixing
const BASS_MUSIC_SINCINTER	=0x800000 ;// sinc interpolated sample mixing
const BASS_MUSIC_POSRESET		=0x8000;	// stop all notes when moving position
const BASS_MUSIC_POSRESETEX	=0x400000; // stop all notes and reset bmp/etc when moving position
const BASS_MUSIC_STOPBACK		=0x80000;	// stop the music on a backwards jump effect
const BASS_MUSIC_NOSAMPLE		=0x100000 ;// don't load the samples

// Speaker assignment flags
const BASS_SPEAKER_FRONT		=0x1000000;	// front speakers
const BASS_SPEAKER_REAR		=0x2000000;	// rear speakers
const BASS_SPEAKER_CENLFE		=0x3000000;	// center & LFE speakers (5.1)
const BASS_SPEAKER_SIDE		=0x4000000;	// side speakers (7.1)
macro bass_speaker_n(n)=>((n)<<24);//const BASS_SPEAKER_N(n)		=((n)<<24);	// n'th pair of speakers (max 15)
const BASS_SPEAKER_LEFT		=0x10000000;	// modifier: left
const BASS_SPEAKER_RIGHT		=0x20000000	;// modifier: right
const BASS_SPEAKER_FRONTLEFT	=BASS_SPEAKER_FRONT | BASS_SPEAKER_LEFT;
const BASS_SPEAKER_FRONTRIGHT	=BASS_SPEAKER_FRONT | BASS_SPEAKER_RIGHT;
const BASS_SPEAKER_REARLEFT	=BASS_SPEAKER_REAR | BASS_SPEAKER_LEFT;
const BASS_SPEAKER_REARRIGHT	=BASS_SPEAKER_REAR | BASS_SPEAKER_RIGHT;
const BASS_SPEAKER_CENTER		=BASS_SPEAKER_CENLFE | BASS_SPEAKER_LEFT;
const BASS_SPEAKER_LFE		=BASS_SPEAKER_CENLFE | BASS_SPEAKER_RIGHT;
const BASS_SPEAKER_SIDELEFT	=BASS_SPEAKER_SIDE | BASS_SPEAKER_LEFT;
const BASS_SPEAKER_SIDERIGHT	=BASS_SPEAKER_SIDE | BASS_SPEAKER_RIGHT;
const BASS_SPEAKER_REAR2		=BASS_SPEAKER_SIDE;
const BASS_SPEAKER_REAR2LEFT	=BASS_SPEAKER_SIDELEFT;
const BASS_SPEAKER_REAR2RIGHT	=BASS_SPEAKER_SIDERIGHT;

const BASS_ASYNCFILE			=0x40000000	;// read file asynchronously
const BASS_UNICODE			=0x80000000	;// UTF-16

const BASS_RECORD_ECHOCANCEL	=0x2000;
const BASS_RECORD_AGC			=0x4000;
const BASS_RECORD_PAUSE		=0x8000	;// start recording paused

// DX7 voice allocation & management flags
const BASS_VAM_HARDWARE		=1;
const BASS_VAM_SOFTWARE		=2;
const BASS_VAM_TERM_TIME		=4;
const BASS_VAM_TERM_DIST		=8;
const BASS_VAM_TERM_PRIO	=16;

// Channel info structure
struct Bass_ChannelInfo{
	uint freq;		// default playback rate
	uint chans;	// channels
	uint flags;
	uint ctype;	// type of channel
	uint origres;	// original resolution
	uint plugin;
	uint sample;
	ZString filename;
} 


const BASS_ORIGRES_FLOAT	=0x10000;

// BASS_CHANNELINFO types
const BASS_CTYPE_SAMPLE	=1;
const BASS_CTYPE_RECORD		=2;
const BASS_CTYPE_STREAM		=0x10000;
const BASS_CTYPE_STREAM_VORBIS	=0x10002;
const BASS_CTYPE_STREAM_OGG	=0x10002;
const BASS_CTYPE_STREAM_MP1	=0x10003;
const BASS_CTYPE_STREAM_MP2	=0x10004;
const BASS_CTYPE_STREAM_MP3	=0x10005;
const BASS_CTYPE_STREAM_AIFF	=0x10006;
const BASS_CTYPE_STREAM_CA	=0x10007;
const BASS_CTYPE_STREAM_MF	=0x10008;
const BASS_CTYPE_STREAM_AM	=0x10009;
const BASS_CTYPE_STREAM_SAMPLE	=0x1000a;
const BASS_CTYPE_STREAM_DUMMY		=0x18000;
const BASS_CTYPE_STREAM_DEVICE	=0x18001;
const BASS_CTYPE_STREAM_WAV	=0x40000 ;// WAVE flag (LOWORD=codec)
const BASS_CTYPE_STREAM_WAV_PCM	=0x50001;
const BASS_CTYPE_STREAM_WAV_FLOAT	=0x50003;
const BASS_CTYPE_MUSIC_MOD	=0x20000;
const BASS_CTYPE_MUSIC_MTM	=0x20001;
const BASS_CTYPE_MUSIC_S3M	=0x20002;
const BASS_CTYPE_MUSIC_XM		=0x20003;
const BASS_CTYPE_MUSIC_IT		=0x20004;
const BASS_CTYPE_MUSIC_MO3	=0x00100 ;// MO3 flag

// BASS_PluginLoad flags
const BASS_PLUGIN_PROC		=1;


struct Bass_PluginForm{
	uint ctype;		// channel type

	ZString name;	// format description
	ZString exts;	// file extension filter (*.ext1;*.ext2;etc...)

} 

struct Bass_PluginInfo{
	uint version;					// version (same form as BASS_GetVersion)
	uint formatc;					// number of formats
	Bass_PluginForm* formats;	// the array of formats
} 

// 3D vector (for 3D positions/velocities/orientations)
struct Bass_3DVector {

	float x;	// +=right, -=left
	float y;	// +=up, -=down
	float z;	// +=front, -=behind
} 

// 3D channel modes
const BASS_3DMODE_NORMAL		=0;	// normal 3D processing
const BASS_3DMODE_RELATIVE	=1	;// position is relative to the listener
const BASS_3DMODE_OFF			=2	;// no 3D processing

// software 3D mixing algorithms (used with BASS_CONFIG_3DALGORITHM)
const BASS_3DALG_DEFAULT	=0;
const BASS_3DALG_OFF		=1;
const BASS_3DALG_FULL		=2;
const BASS_3DALG_LIGHT	=3;

// BASS_SampleGetChannel flags
const BASS_SAMCHAN_NEW		=1;	// get a new playback channel
const BASS_SAMCHAN_STREAM		=2;	// create a stream

def StreamProc=fn ulong (uint handle, void *buffer, uint length, void *user);
/* User stream callback function.
handle : The stream that needs writing
buffer : Buffer to write the samples in
length : Number of bytes to write
user   : The 'user' parameter value given when calling BASS_StreamCreate
RETURN : Number of bytes written. Set the BASS_STREAMPROC_END flag to end the stream. */

const BASS_STREAMPROC_END		=0x80000000;	// end of user stream flag

// Special STREAMPROCs
const STREAMPROC_DUMMY		=(StreamProc*)0	;	// "dummy" stream
//const STREAMPROC_PUSH			=(StreamProc*)-1;		// push stream
//const STREAMPROC_DEVICE		=(StreamProc*)-2	;	// device mix stream
//const STREAMPROC_DEVICE_3D	=(StreamProc*)-3	;	// device 3D mix stream

// BASS_StreamCreateFileUser file systems
const STREAMFILE_NOBUFFER		=0;
const STREAMFILE_BUFFER		=1;
const STREAMFILE_BUFFERPUSH	=2;

// User file stream callback functions
def FileCloseProc= fn void (void *user);
def FileLenProc=fn ulong(void *user);
def FileReadProc=fn uint(void *buffer, uint length, void *user);
def FileSeekProc=fn bool(ulong offset, void *user);

struct Bass_FileProc{
	FileCloseProc *close;
	FileLenProc *length;
	FileReadProc *read;
	FileSeekProc *seek;
} 


// BASS_StreamPutFileData options
const BASS_FILEDATA_END		=0;	// end & close the file

// BASS_StreamGetFilePosition modes
const BASS_FILEPOS_CURRENT	=0;
const BASS_FILEPOS_DECODE		=BASS_FILEPOS_CURRENT;
const BASS_FILEPOS_DOWNLOAD	=1;
const BASS_FILEPOS_END		=2;
const BASS_FILEPOS_START		=3;
const BASS_FILEPOS_CONNECTED	=4;
const BASS_FILEPOS_BUFFER		=5;
const BASS_FILEPOS_SOCKET		=6;
const BASS_FILEPOS_ASYNCBUF	=7;
const BASS_FILEPOS_SIZE		=8;
const BASS_FILEPOS_BUFFERING	=9;
const BASS_FILEPOS_AVAILABLE	=10;

def DownloadProc=fn  void(void *buffer, uint length, void *user);
/* Internet stream download callback function.
buffer : Buffer containing the downloaded data... NULL=end of download
length : Number of bytes in the buffer
user   : The 'user' parameter value given when calling BASS_StreamCreateURL */

// BASS_ChannelSetSync types
const BASS_SYNC_POS			=0;
const BASS_SYNC_END			=2;
const BASS_SYNC_META			=4;
const BASS_SYNC_SLIDE			=5;
const BASS_SYNC_STALL			=6;
const BASS_SYNC_DOWNLOAD		=7;
const BASS_SYNC_FREE			=8;
const BASS_SYNC_SETPOS		=11;
const BASS_SYNC_MUSICPOS		=10;
const BASS_SYNC_MUSICINST		=1;
const BASS_SYNC_MUSICFX		=3;
const BASS_SYNC_OGG_CHANGE	=12;
const BASS_SYNC_DEV_FAIL		=14;
const BASS_SYNC_DEV_FORMAT	=15;
const BASS_SYNC_THREAD		=0x20000000	;// flag: call sync in other thread
const BASS_SYNC_MIXTIME		=0x40000000	;// flag: sync at mixtime, else at playtime
const BASS_SYNC_ONETIME		=0x80000000;	// flag: sync only once, else continuously


def SyncProc=fn void(uint handle, uint channel, uint data, void *user);
/* Sync callback function.
handle : The sync that has occured
channel: Channel that the sync occured in
data   : Additional data associated with the sync's occurance
user   : The 'user' parameter given when calling BASS_ChannelSetSync */

def DspProc=fn void(uint handle, uint channel, void *buffer, uint length, void *user);
/* DSP callback function.
handle : The DSP handle
channel: Channel that the DSP is being applied to
buffer : Buffer to apply the DSP to
length : Number of bytes in the buffer
user   : The 'user' parameter given when calling BASS_ChannelSetDSP */

def RecordProc=fn bool(uint handle,void *buffer, uint length, void *user);
/* Recording callback function.
handle : The recording handle
buffer : Buffer containing the recorded sample data
length : Number of bytes
user   : The 'user' parameter value given when calling BASS_RecordStart
RETURN : TRUE = continue recording, FALSE = stop */


// BASS_ChannelIsActive return values
const BASS_ACTIVE_STOPPED			=0;
const BASS_ACTIVE_PLAYING			=1;
const BASS_ACTIVE_STALLED			=2;
const BASS_ACTIVE_PAUSED			=3;
const BASS_ACTIVE_PAUSED_DEVICE	=4;

// Channel attributes
const BASS_ATTRIB_FREQ			=1;
const BASS_ATTRIB_VOL				=2;
const BASS_ATTRIB_PAN				=3;
const BASS_ATTRIB_EAXMIX			=4;
const BASS_ATTRIB_NOBUFFER		=5;
const BASS_ATTRIB_VBR				=6;
const BASS_ATTRIB_CPU				=7;
const BASS_ATTRIB_SRC				=8;
const BASS_ATTRIB_NET_RESUME		=9;
const BASS_ATTRIB_SCANINFO		=10;
const BASS_ATTRIB_BITRATE			=12;
const BASS_ATTRIB_BUFFER			=13;
const BASS_ATTRIB_GRANULE			=14;
const BASS_ATTRIB_USER			=15;
const BASS_ATTRIB_TAIL			=16;
const BASS_ATTRIB_PUSH_LIMIT		=17;
const BASS_ATTRIB_DOWNLOADPROC	=18;
const BASS_ATTRIB_VOLDSP			=19;
const BASS_ATTRIB_VOLDSP_PRIORITY	=20;
const BASS_ATTRIB_MUSIC_AMPLIFY	=0x100;
const BASS_ATTRIB_MUSIC_PANSEP	=0x101;
const BASS_ATTRIB_MUSIC_PSCALER	=0x102;
const BASS_ATTRIB_MUSIC_BPM		=0x103;
const BASS_ATTRIB_MUSIC_SPEED		=0x104;
const BASS_ATTRIB_MUSIC_VOL_GLOBAL =0x105;
const BASS_ATTRIB_MUSIC_ACTIVE	=0x106;
const BASS_ATTRIB_MUSIC_VOL_CHAN	=0x200 ;// + channel #
const BASS_ATTRIB_MUSIC_VOL_INST	=0x300 ;// + instrument #

// BASS_ChannelSlideAttribute flags
const BASS_SLIDE_LOG				=0x1000000;

// BASS_ChannelGetData flags
const BASS_DATA_AVAILABLE	=0		;	// query how much data is buffered
const BASS_DATA_NOREMOVE	=0x10000000	;// flag: don't remove data from recording buffer
const BASS_DATA_FIXED		=0x20000000;	// unused
const BASS_DATA_FLOAT		=0x40000000	;// flag: return floating-point sample data
const BASS_DATA_FFT256	=0x80000000	;// 256 sample FFT
const BASS_DATA_FFT512	=0x80000001	;// 512 FFT
const BASS_DATA_FFT1024	=0x80000002	;// 1024 FFT
const BASS_DATA_FFT2048	=0x80000003	;// 2048 FFT
const BASS_DATA_FFT4096	=0x80000004	;// 4096 FFT
const BASS_DATA_FFT8192	=0x80000005	;// 8192 FFT
const BASS_DATA_FFT16384	=0x80000006	;// 16384 FFT
const BASS_DATA_FFT32768	=0x80000007;	// 32768 FFT
const BASS_DATA_FFT_INDIVIDUAL =0x10;	// FFT flag: FFT for each channel, else all combined
const BASS_DATA_FFT_NOWINDOW	=0x20;	// FFT flag: no Hanning window
const BASS_DATA_FFT_REMOVEDC	=0x40;	// FFT flag: pre-remove DC bias
const BASS_DATA_FFT_COMPLEX	=0x80	;// FFT flag: return complex data
const BASS_DATA_FFT_NYQUIST	=0x100;	// FFT flag: return extra Nyquist value

// BASS_ChannelGetLevelEx flags
const BASS_LEVEL_MONO		=1;	// get mono level
const BASS_LEVEL_STEREO	=2	;// get stereo level
const BASS_LEVEL_RMS		=4;	// get RMS levels
const BASS_LEVEL_VOLPAN	=8;	// apply VOL/PAN attributes to the levels
const BASS_LEVEL_NOREMOVE	=16;	// don't remove data from recording buffer

// BASS_ChannelGetTags types : what's returned
const BASS_TAG_ID3		=0;	// ID3v1 tags : TAG_ID3 structure
const BASS_TAG_ID3V2		=1	;// ID3v2 tags : variable length block
const BASS_TAG_OGG		=2	;// OGG comments : series of null-terminated UTF-8 strings
const BASS_TAG_HTTP		=3	;// HTTP headers : series of null-terminated ASCII strings
const BASS_TAG_ICY		=4	;// ICY headers : series of null-terminated ANSI strings
const BASS_TAG_META		=5;	// ICY metadata : ANSI string
const BASS_TAG_APE		=6	;// APE tags : series of null-terminated UTF-8 strings
const BASS_TAG_MP4 		=7	;// MP4/iTunes metadata : series of null-terminated UTF-8 strings
const BASS_TAG_WMA		=8;	// WMA tags : series of null-terminated UTF-8 strings
const BASS_TAG_VENDOR		=9;	// OGG encoder : UTF-8 string
const BASS_TAG_LYRICS3	=10;	// Lyric3v2 tag : ASCII string
const BASS_TAG_CA_CODEC	=11;	// CoreAudio codec info : TAG_CA_CODEC structure
const BASS_TAG_MF			=13;	// Media Foundation tags : series of null-terminated UTF-8 strings
const BASS_TAG_WAVEFORMAT	=14	;// WAVE format : WAVEFORMATEEX structure
const BASS_TAG_AM_NAME	=16	;// Android Media codec name : ASCII string
const BASS_TAG_ID3V2_2	=17;	// ID3v2 tags (2nd block) : variable length block
const BASS_TAG_AM_MIME	=18	;// Android Media MIME type : ASCII string
const BASS_TAG_LOCATION	=19	;// redirected URL : ASCII string
const BASS_TAG_RIFF_INFO	=0x100 ;// RIFF "INFO" tags : series of null-terminated ANSI strings
const BASS_TAG_RIFF_BEXT	=0x101 ;// RIFF/BWF "bext" tags : TAG_BEXT structure
const BASS_TAG_RIFF_CART	=0x102 ;// RIFF/BWF "cart" tags : TAG_CART structure
const BASS_TAG_RIFF_DISP	=0x103; // RIFF "DISP" text tag : ANSI string
const BASS_TAG_RIFF_CUE	=0x104; // RIFF "cue " chunk : TAG_CUE structure
const BASS_TAG_RIFF_SMPL	=0x105 ;// RIFF "smpl" chunk : TAG_SMPL structure
const BASS_TAG_APE_BINARY	=0x1000;	// + index #, binary APE tag : TAG_APE_BINARY structure
const BASS_TAG_MUSIC_NAME		=0x10000;	// MOD music name : ANSI string
const BASS_TAG_MUSIC_MESSAGE	=0x10001;	// MOD message : ANSI string
const BASS_TAG_MUSIC_ORDERS	=0x10002;	// MOD order list : BYTE array of pattern numbers
const BASS_TAG_MUSIC_AUTH		=0x10003;	// MOD author : UTF-8 string
const BASS_TAG_MUSIC_INST		=0x10100;	// + instrument #, MOD instrument name : ANSI string
const BASS_TAG_MUSIC_CHAN		=0x10200;	// + channel #, MOD channel name : ANSI string
const BASS_TAG_MUSIC_SAMPLE	=0x10300;	// + sample #, MOD sample name : ANSI string



// ID3v1 tag structure
struct Tag_ID3{
	char[3] id;
	char[30] title;
	char[30] artist;
	char[30] album;
	char[4] year;
	char[30] comment;
	char genre;
} 

// Binary APE tag structure
struct Tag_Ape_Binary{
	ZString key;
	void *data;
	uint length;
} 


struct Tag_Bext{
	char[256] description;			// description
	char[32] originator;			// name of the originator
	char[32] originatorReference;	// reference of the originator
	char[10] originationDate;		// date of creation (yyyy-mm-dd)
	char[8] originationTime;		// time of creation (hh-mm-ss)
	ulong timeReference;			// first sample count since midnight (little-endian)
	uint version;					// BWF version (little-endian)
	char[64] umid;					// SMPTE UMID
	char[190] reserved;
    char[1] codingHistory;

} 

// BWF "cart" tag structures
struct Tag_Cart_Timer
{
	uint dwUsage;					// FOURCC timer usage ID
	uint dwValue;					// timer value in samples from head
} 

struct Tag_Cart
{
	char[4] version;				// version of the data structure
	char[64] title;					// title of cart audio sequence
	char[64] artist;				// artist or creator name
	char[64] cutID;					// cut number identification
	char[64] clientID;				// client identification
	char[64] category;				// category ID, PSA, NEWS, etc
	char[64] classification;		// classification or auxiliary key
	char[64] outCue;				// out cue text
	char[10] startDate;				// yyyy-mm-dd
	char[8] startTime;				// hh:mm:ss
	char[10] endDate;				// yyyy-mm-dd
	char[8] endTime;				// hh:mm:ss
	char[64] producerAppID;			// name of vendor or application
	char[64] producerAppVersion;	// version of producer application
	char[64] userDef;				// user defined text
	uint dwLevelReference;			// sample value for 0 dB reference
	Tag_Cart_Timer[8] postTimer;	// 8 time markers after head
	char[276] reserved;
	char[1024] url;		
    char[1] tagTex;// uniform resource locator

} 

// RIFF "cue " tag structures
struct Tag_Cue_Point
{
	uint dwName;
	uint dwPosition;
	uint fccChunk;
	uint dwChunkStart;
	uint dwBlockStart;
	uint dwSampleOffset;
} 

struct Tag_Cue
{
	uint dwCuePoints;
    Tag_Cue_Point[1] cuePoint;

} 

// RIFF "smpl" tag structures
struct Tag_Smpl_Loop
{
	uint dwIdentifier;
	uint dwType;
	uint dwStart;
	uint dwEnd;
	uint dwFraction;
	uint dwPlayCount;
} 

struct Tag_Smpl
{
	uint dwManufacturer;
	uint dwProduct;
	uint dwSamplePeriod;
	uint dwMIDIUnityNote;
	uint dwMIDIPitchFraction;
	uint dwSMPTEFormat;
	uint dwSMPTEOffset;
	uint cSampleLoops;
	uint cbSamplerData;
    Tag_Smpl_Loop[1] sampleLoops;

} 

// CoreAudio codec info structure
struct Tag_Ca_Codec{
	uint ftype;					// file format
	uint atype;					// audio format
	ZString name;				// description
} 

/*
#ifndef _WAVEFORMATEX_
const _WAVEFORMATEX_
#pragma pack(push,1)
*/
struct WaveFormatEx
{
	uint wFormatTag;
	uint nChannels;
	uint nSamplesPerSec;
	uint nAvgBytesPerSec;
	uint nBlockAlign;
	uint wBitsPerSample;
	uint cbSize;

}


//WAVEFORMATEX, *PWAVEFORMATEX, *LPWAVEFORMATEX;
//typedef const WAVEFORMATEX *LPCWAVEFORMATEX;
//#pragma pack(pop)
//#endif

// BASS_ChannelGetLength/GetPosition/SetPosition modes
const BASS_POS_BYTE			=0	;	// byte position
const BASS_POS_MUSIC_ORDER	=1	;	// order.row position, MAKELONG(order,row)
const BASS_POS_OGG			=3	;	// OGG bitstream number
const BASS_POS_END			=0x10;	// trimmed end position
const BASS_POS_LOOP			=0x11;	// loop start positiom
const BASS_POS_FLUSH			=0x1000000 ;// flag: flush decoder/FX buffers
const BASS_POS_RESET			=0x2000000; // flag: reset user file buffers
const BASS_POS_RELATIVE		=0x4000000; // flag: seek relative to the current position
const BASS_POS_INEXACT		=0x8000000; // flag: allow seeking to inexact position
const BASS_POS_DECODE			=0x10000000 ;// flag: get the decoding (not playing) position
const BASS_POS_DECODETO		=0x20000000 ;// flag: decode to the position instead of seeking
const BASS_POS_SCAN			=0x40000000; // flag: scan to the position

// BASS_ChannelSetDevice/GetDevice option
const BASS_NODEVICE		=0x20000;

// BASS_RecordSetInput flags
const BASS_INPUT_OFF		=0x10000;
const BASS_INPUT_ON		=0x20000;

const BASS_INPUT_TYPE_MASK		=0xff000000;
const BASS_INPUT_TYPE_UNDEF		=0x00000000;
const BASS_INPUT_TYPE_DIGITAL		=0x01000000;
const BASS_INPUT_TYPE_LINE		=0x02000000;
const BASS_INPUT_TYPE_MIC			=0x03000000;
const BASS_INPUT_TYPE_SYNTH		=0x04000000;
const BASS_INPUT_TYPE_CD			=0x05000000;
const BASS_INPUT_TYPE_PHONE		=0x06000000;
const BASS_INPUT_TYPE_SPEAKER		=0x07000000;
const BASS_INPUT_TYPE_WAVE		=0x08000000;
const BASS_INPUT_TYPE_AUX			=0x09000000;
const BASS_INPUT_TYPE_ANALOG		=0x0a000000;

// BASS_ChannelSetFX effect types
const BASS_FX_DX8_CHORUS			=0;
const BASS_FX_DX8_COMPRESSOR		=1;
const BASS_FX_DX8_DISTORTION		=2;
const BASS_FX_DX8_ECHO			=3;
const BASS_FX_DX8_FLANGER			=4;
const BASS_FX_DX8_GARGLE			=5;
const BASS_FX_DX8_I3DL2REVERB		=6;
const BASS_FX_DX8_PARAMEQ			=7;
const BASS_FX_DX8_REVERB		=8;
const BASS_FX_VOLUME				=9;

struct Bass_DX8_Chorus{
	float       fWetDryMix;
	float       fDepth;
	float       fFeedback;
	float       fFrequency;
	uint       lWaveform;	// 0=triangle, 1=sine
	float       fDelay;
	uint       lPhase;		// BASS_DX8_PHASE_xxx
} 

struct Bass_DX8_Compressor{
	float   fGain;
	float   fAttack;
	float   fRelease;
	float   fThreshold;
	float   fRatio;
	float   fPredelay;
} 

struct Bass_DX8_Distortion{
	float   fGain;
	float   fEdge;
	float   fPostEQCenterFrequency;
	float   fPostEQBandwidth;
	float   fPreLowpassCutoff;
} 

struct Bass_DX8_Echo{
	float   fWetDryMix;
	float   fFeedback;
	float   fLeftDelay;
	float   fRightDelay;
	bool    lPanDelay;
} 

struct Bass_DX8_Flanger{
	float       fWetDryMix;
	float       fDepth;
	float       fFeedback;
	float       fFrequency;
	uint       lWaveform;	// 0=triangle, 1=sine
	float       fDelay;
	uint       lPhase;		// BASS_DX8_PHASE_xxx
}

struct Bass_DX8_Gargle{
	uint       dwRateHz;               // Rate of modulation in hz
	uint       dwWaveShape;            // 0=triangle, 1=square
}

struct Bass_DX8_I3Dl2reverb{
	int     lRoom;                  // [-10000, 0]      default: -1000 mB
	int     lRoomHF;                // [-10000, 0]      default: 0 mB
	float   flRoomRolloffFactor;    // [0.0, 10.0]      default: 0.0
	float   flDecayTime;            // [0.1, 20.0]      default: 1.49s
	float   flDecayHFRatio;         // [0.1, 2.0]       default: 0.83
	int     lReflections;           // [-10000, 1000]   default: -2602 mB
	float   flReflectionsDelay;     // [0.0, 0.3]       default: 0.007 s
	int     lReverb;                // [-10000, 2000]   default: 200 mB
	float   flReverbDelay;          // [0.0, 0.1]       default: 0.011 s
	float   flDiffusion;            // [0.0, 100.0]     default: 100.0 %
	float   flDensity;              // [0.0, 100.0]     default: 100.0 %
	float   flHFReference;          // [20.0, 20000.0]  default: 5000.0 Hz
} 

struct Bass_DX8_ParamEQ{
	float   fCenter;
	float   fBandwidth;
	float   fGain;
} 

struct Bass_DX8_Reverb{
	float   fInGain;                // [-96.0,0.0]            default: 0.0 dB
	float   fReverbMix;             // [-96.0,0.0]            default: 0.0 db
	float   fReverbTime;            // [0.001,3000.0]         default: 1000.0 ms
	float   fHighFreqRTRatio;       // [0.001,0.999]          default: 0.001
} 

const BASS_DX8_PHASE_NEG_180       = 0;
const BASS_DX8_PHASE_NEG_90        = 1;
const BASS_DX8_PHASE_ZERO           =2;
const BASS_DX8_PHASE_90            = 3;
const BASS_DX8_PHASE_180           = 4;

struct Bass_FX_Volume_Param{
	float fTarget;
	float fCurrent;
	float fTime;
	uint lCurve;
} 

def IosNotifyProc=fn void(uint status);
/* iOS notification callback function.
status : The notification (BASS_IOSNOTIFY_xxx) */

const BASS_IOSNOTIFY_INTERRUPT		=1;	// interruption started
const BASS_IOSNOTIFY_INTERRUPT_END	=2;	// interruption ended

extern fn bool bass_setConfig(uint option,uint value) @extern("BASS_SetConfig");//BOOL BASSDEF(BASS_SetConfig)(DWORD option, DWORD value);
extern fn bool bass_getConfig(uint option) @extern("BASS_GetConfig");//DWORD BASSDEF(BASS_GetConfig)(DWORD option);
extern fn bool bass_setConfigPtr(uint option,void* value) @extern("BASS_SetConfigPtr");//BOOL BASSDEF(BASS_SetConfigPtr)(DWORD option, const void *value);
extern fn void* bass_getConfigPtr(uint option) @extern("BASS_GetConfigPtr");
extern fn uint bass_getVersion() @extern("BASS_GetVersion") ;//DWORD BASSDEF(BASS_GetVersion)(void);
extern fn int bass_errorGetCode() @extern("BASS_ErrorGetCode");//BASSDEF(BASS_ErrorGetCode)(void);

extern fn bool bass_getDeviceInfo(uint device,Bass_DeviceInfo* info) @extern("BASS_GetDeviceInfo");//BOOL BASSDEF(BASS_GetDeviceInfo)(DWORD device, BASS_DEVICEINFO *info);
//#if defined(_WIN32) && !defined(_WIN32_WCE) && !(defined(WINAPI_FAMILY) && WINAPI_FAMILY != WINAPI_FAMILY_DESKTOP_APP)
//BOOL BASSDEF(BASS_Init)(int device, DWORD freq, DWORD flags, HWND win, const void *dsguid);
//#else
extern fn bool bass_init(int device,uint freq,uint flags,void* win,void* dsguid) @extern("BASS_Init");//BOOL BASSDEF(BASS_Init)(int device, DWORD freq, DWORD flags, void *win, const void *dsguid);
//#endif
extern fn bool bass_free() @extern("BASS_Free");//BOOL BASSDEF(BASS_Free)(void);
extern fn bool bass_setDevice(uint device) @extern("BASS_SetDevice");//BOOL BASSDEF(BASS_SetDevice)(DWORD device);
extern fn uint bass_getDevice() @extern("BASS_GetDevice");//DWORD BASSDEF(BASS_GetDevice)(void);
extern fn bool bass_getInfo(Bass_Info* info) @extern("BASS_GetInfo");//BOOL BASSDEF(BASS_GetInfo)(BASS_INFO *info);
extern fn bool bass_start() @extern("BASS_Start");//BOOL BASSDEF(BASS_Start)(void);
extern fn bool bass_stop() @extern("BASS_Stop");//BOOL BASSDEF(BASS_Stop)(void);
extern fn bool bass_pause() @extern("BASS_Pause");//BOOL BASSDEF(BASS_Pause)(void);
extern fn uint bass_isStarted() @extern("BASS_IsStarted");//DWORD BASSDEF(BASS_IsStarted)(void);
extern fn bool bass_update(uint length) @extern("BASS_Update");//BOOL BASSDEF(BASS_Update)(DWORD length);
extern fn float bass_getCPU() @extern("BASS_GetCPU");// BASSDEF(BASS_GetCPU)(void);
extern fn bool bass_setVolume(float volume) @extern("BASS_SetVolume");//BOOL BASSDEF(BASS_SetVolume)(float volume);
extern fn float bass_getVolume() @extern("BASS_GetVolume");//BASSDEF(BASS_GetVolume)(void);
//#if defined(_WIN32) && !defined(_WIN32_WCE) && !(defined(WINAPI_FAMILY) && WINAPI_FAMILY != WINAPI_FAMILY_DESKTOP_APP)
extern fn void* bass_getDSoundObject(uint object) @extern("BASS_GetDSoundObject");//BASSDEF(BASS_GetDSoundObject)(DWORD object);
//#endif

extern fn bool bass_set3DFactors(float distf,float rollf,float doppf) @extern("BASS_Set3DFactors");//BOOL BASSDEF(BASS_Set3DFactors)(float distf, float rollf, float doppf);
extern fn bool bass_GEt3DFactors(float* disf,float* rollf,float* doppf) @extern("BASS_Get3DFactors");//BOOL BASSDEF(BASS_Get3DFactors)(float *distf, float *rollf, float *doppf);
extern fn bool bass_set3DPosition(Bass_3DVector* pos,Bass_3DVector* vel,Bass_3DVector* front,Bass_3DVector* top) @extern("BASS_Set3DPosition");//BOOL BASSDEF(BASS_Set3DPosition)(const BASS_3DVECTOR *pos, const BASS_3DVECTOR *vel, const BASS_3DVECTOR *front, const BASS_3DVECTOR *top);
extern fn bool bass_get3DPositon(Bass_3DVector* pos,Bass_3DVector* vel,Bass_3DVector* front,Bass_3DVector* top) @extern("BASS_Get3DPosition");//BOOL BASSDEF(BASS_Get3DPosition)(BASS_3DVECTOR *pos, BASS_3DVECTOR *vel, BASS_3DVECTOR *front, BASS_3DVECTOR *top);
extern fn void bass_apply3D();//BASSDEF(BASS_Apply3D)(void);

extern fn uint bass_pluinLoad(ZString file,uint flags) @extern("BASS_PluginLoad");//HPLUGIN BASSDEF(BASS_PluginLoad)(ZString file, DWORD flags);
extern fn bool bass_pluginFree(uint handle) @extern("BASS_PluginFree");//BOOL BASSDEF(BASS_PluginFree)(HPLUGIN handle);
extern fn bool bass_pluginEnable(uint handle,bool enable) @extern("BASS_PluginEnable");//BOOL BASSDEF(BASS_PluginEnable)(HPLUGIN handle, BOOL enable);
extern fn Bass_PluginInfo* bass_pluginGetInfo(uint handle) @extern("BASS_PluginGetInfo");//const BASS_PLUGININFO *BASSDEF(BASS_PluginGetInfo)(HPLUGIN handle);

extern fn uint bass_sampleLoad(bool mem,void* file,ulong offse,uint length,uint max,uint flags) @extern("BASS_SampleLoad");//HSAMPLE BASSDEF(BASS_SampleLoad)(BOOL mem, const void *file, QWORD offset, DWORD length, DWORD max, DWORD flags);
extern fn uint bass_sampleCreate(uint length,uint freq,uint chans,uint max,uint flags) @extern("BASS_SampleCreate");//HSAMPLE BASSDEF(BASS_SampleCreate)(DWORD length, DWORD freq, DWORD chans, DWORD max, DWORD flags);
extern fn bool bass_sampleFree(uint handle) @extern("BASS_SampleFree");//BOOL BASSDEF(BASS_SampleFree)(HSAMPLE handle);
extern fn bool bass_sampleSetData(uint handle,void* buffer) @extern("BASS_SampleSetData");//BOOL BASSDEF(BASS_SampleSetData)(HSAMPLE handle, const void *buffer);
extern fn bool bass_sampleGetData(uint handle,void* buffer) @extern("BASS_SampleGetData");//BOOL BASSDEF(BASS_SampleGetData)(HSAMPLE handle, void *buffer);
extern fn bool bass_sampleGetInfo(uint handle,Bass_Sample* info) @extern("BASS_SampleGetInfo");//BOOL BASSDEF(BASS_SampleGetInfo)(HSAMPLE handle, BASS_SAMPLE *info);
extern fn bool bass_sampleSetInfo(uint handle,Bass_Sample* info) @extern("BASS_SampleSetInfo");//BOOL BASSDEF(BASS_SampleSetInfo)(HSAMPLE handle, const BASS_SAMPLE *info);
extern fn uint bass_sampleGetChannel(uint handle,uint flags) @extern("BASS_SampleGetChanel");//DWORD BASSDEF(BASS_SampleGetChannel)(HSAMPLE handle, DWORD flags);
extern fn uint bass_sampleGetChannels(uint handle,uint* channels) @extern("BASS_SampleGetChannels");//DWORD BASSDEF(BASS_SampleGetChannels)(HSAMPLE handle, HCHANNEL *channels);
extern fn bool bass_sampleStop(uint handle) @extern("BASS_SampleStop");//BOOL BASSDEF(BASS_SampleStop)(HSAMPLE handle);

extern fn uint bass_streamCreate(uint freq,uint chans,uint flags,StreamProc* proc,void* user) @extern("BASS_StreamCreate");//HSTREAM BASSDEF(BASS_StreamCreate)(DWORD freq, DWORD chans, DWORD flags, STREAMPROC *proc, void *user);
extern fn uint bass_streamCreateFile(bool mem,void* file,ulong offset,ulong length,uint flags) @extern("BASS_StreamCreateFile");//HSTREAM BASSDEF(BASS_StreamCreateFile)(BOOL mem, const void *file, QWORD offset, QWORD length, DWORD flags);
extern fn uint bass_streamCreateURL(ZString rul,uint offset,uint flags,DownloadProc* proc,void* user) @extern("BASS_StreamCreateURL");//HSTREAM BASSDEF(BASS_StreamCreateURL)(ZString url, DWORD offset, DWORD flags, DOWNLOADPROC *proc, void *user);
extern fn uint bass_stream_createFileUser(uint system,uint flags,Bass_FileProc* proc,void* user) @extern("BASS_StreamCreateFileUser");//HSTREAM BASSDEF(BASS_StreamCreateFileUser)(DWORD system, DWORD flags, const BASS_FILEPROCS *proc, void *user);
extern fn bool bass_streamFree(uint handle) @extern("BASS_StreamFree");//BOOL BASSDEF(BASS_StreamFree)(HSTREAM handle) ;
extern fn ulong bass_streamGetFilePosition(uint handle,uint mode) @extern("BASS_StreamGetFilePosition");//QWORD BASSDEF(BASS_StreamGetFilePosition)(HSTREAM handle, DWORD mode);
extern fn uint bass_streamPutData(uint handle,void* buffer,uint length) @extern("BASS_StreamPutData");//DWORD BASSDEF(BASS_StreamPutData)(HSTREAM handle, const void *buffer, DWORD length);
extern fn uint bass_streamPutFileData(uint handle,void* buffer,uint length) @extern("BASS_StreamPutFileData");//DWORD BASSDEF(BASS_StreamPutFileData)(HSTREAM handle, const void *buffer, DWORD length);

extern fn uint bass_musicLoad(bool mem,void* file,ulong offse,uint length,uint flags,uint freq) @extern("BASS_MusicLoad");//HMUSIC BASSDEF(BASS_MusicLoad)(BOOL mem, const void *file, QWORD offset, DWORD length, DWORD flags, DWORD freq);
extern fn bool bass_musicFree(uint handle) @extern("BASS_MusicFree");//BOOL BASSDEF(BASS_MusicFree)(HMUSIC handle);

extern fn bool bass_recordGetDeviceInfo(uint device,Bass_DeviceInfo* info) @extern("BASS_RecordGetDeviceInfo");//BOOL BASSDEF(BASS_RecordGetDeviceInfo)(DWORD device, BASS_DEVICEINFO *info);
extern fn bool bass_recordInit(int device) @extern("BASS_RecordInit");//BOOL BASSDEF(BASS_RecordInit)(int device);
extern fn bool bass_recordFree() @extern("BASS_RecordFree");//BOOL BASSDEF(BASS_RecordFree)(void);
extern fn bool bass_recordSetDevice(uint device) @extern("BASS_RecordSetDevice");//BOOL BASSDEF(BASS_RecordSetDevice)(DWORD device);
extern fn uint bass_recordGetDevice() @extern("BASS_RecordGetDevice");//DWORD BASSDEF(BASS_RecordGetDevice)(void);
extern fn bool bass_recordGetInfo(Bass_RecordInfo* info) @extern("BASS_RecordGetInfo");//BOOL BASSDEF(BASS_RecordGetInfo)(BASS_RECORDINFO *info);
extern fn ZString bass_recordGetInputName(int input) @extern("BASS_RecordGetInputName");//BASSDEF(BASS_RecordGetInputName)(int input);
extern fn bool bass_recordSetInput(int input,uint flags,float volume) @extern("BASS_RecordSetInput");//BOOL BASSDEF(BASS_RecordSetInput)(int input, DWORD flags, float volume);
extern fn uint bass_recordGetInput(int input,float* volume) @extern("BASS_RecordGetInput");//DWORD BASSDEF(BASS_RecordGetInput)(int input, float *volume);
extern fn uint bass_recordStart(uint freq,uint chans,uint flags,RecordProc* proc,void* user) @extern("BASS_RecordStart");//HRECORD BASSDEF(BASS_RecordStart)(DWORD freq, DWORD chans, DWORD flags, RECORDPROC *proc, void *user);

extern fn double bass_channelBytes2Seconds(uint handle,ulong pos) @extern("BASS_ChannelBytes2Seconds");//BASSDEF(BASS_ChannelBytes2Seconds)(DWORD handle, QWORD pos);
extern fn ulong bass_ChannelSeconds2Bytes(uint handle,double pos) @extern("BASS_ChannelSeconds2Bytes");//QWORD BASSDEF(BASS_ChannelSeconds2Bytes)(DWORD handle, double pos);
extern fn uint bass_channelGetDevice(uint handle) @extern("BASS_ChannelGetDevice");//DWORD BASSDEF(BASS_ChannelGetDevice)(DWORD handle);
extern fn bool bass_channelSetDevice(uint handle,uint device) @extern("BASS_ChannelSetDevice");//BOOL BASSDEF(BASS_ChannelSetDevice)(DWORD handle, DWORD device);
extern fn uint bass_channelIsActive(uint handle) @extern("BASS_ChannelIsActive");//DWORD BASSDEF(BASS_ChannelIsActive)(DWORD handle);
extern fn bool bass_channelGetInfo(uint handle,Bass_ChannelInfo* info) @extern("BASS_ChannelGetInfo");//BOOL BASSDEF(BASS_ChannelGetInfo)(DWORD handle, BASS_CHANNELINFO *info);
extern fn ZString bass_channelGetTags(uint handle,uint tags) @extern("BASS_ChannelGetTags");//BASSDEF(BASS_ChannelGetTags)(DWORD handle, DWORD tags);
extern fn uint bass_channelFlags(uint handle,uint flags,uint mask) @extern("BASS_ChannelFlags");//DWORD BASSDEF(BASS_ChannelFlags)(DWORD handle, DWORD flags, DWORD mask);
extern fn bool bass_channelLock(uint handle,bool lock) @extern("BASS_ChannelLock");//BOOL BASSDEF(BASS_ChannelLock)(DWORD handle, BOOL lock);
extern fn bool bass_channelFree(uint handle) @extern("BASS_ChannelFree");//BOOL BASSDEF(BASS_ChannelFree)(DWORD handle);
extern fn bool bass_channelPlay(uint handle,bool restart) @extern("BASS_ChannelPlay");//BOOL BASSDEF(BASS_ChannelPlay)(DWORD handle, BOOL restart);
extern fn bool bass_channelStart(uint handle) @extern("BASS_ChannelStart");//BOOL BASSDEF(BASS_ChannelStart)(DWORD handle);
extern fn bool bass_channelStop(uint handle) @extern("BASS_ChannelStop");//BOOL BASSDEF(BASS_ChannelStop)(DWORD handle);
extern fn bool bass_channelPause(uint handle) @extern("BASS_ChannelPause");//BOOL BASSDEF(BASS_ChannelPause)(DWORD handle);
extern fn bool bass_channelUpdate(uint handle,uint length) @extern("BASS_ChannelUpdate");//BOOL BASSDEF(BASS_ChannelUpdate)(DWORD handle, DWORD length);
extern fn bool bass_channelSetAttribute(uint handle,uint arrtib,float value) @extern("BASS_ChannelSetAttribute");//BOOL BASSDEF(BASS_ChannelSetAttribute)(DWORD handle, DWORD attrib, float value);
extern fn bool bass_channelGetAttribute(uint handle,uint attrib,float* value) @extern("BASS_ChannelGetAttribute");//BOOL BASSDEF(BASS_ChannelGetAttribute)(DWORD handle, DWORD attrib, float *value);
extern fn bool bass_channelSlideAttribute(uint handle,uint arrtib,float value,uint time) @extern("BASS_ChannelSlideAttribute");//BOOL BASSDEF(BASS_ChannelSlideAttribute)(DWORD handle, DWORD attrib, float value, DWORD time);
extern fn bool bass_channelIsSliding(uint handle,uint arrtib) @extern("BASS_ChannelIsSliding");//BOOL BASSDEF(BASS_ChannelIsSliding)(DWORD handle, DWORD attrib);
extern fn bool bass_channelSetAttributeEx(uint handle,uint attrib,void* value,uint size) @extern("BASS_ChannelSetAttributeEx");//BOOL BASSDEF(BASS_ChannelSetAttributeEx)(DWORD handle, DWORD attrib, void *value, DWORD size);
extern fn uint bass_channelGetAttributeEx(uint handle,uint attrib,void* value,uint size) @extern("BASS_ChannelGetAttributeEx");//DWORD BASSDEF(BASS_ChannelGetAttributeEx)(DWORD handle, DWORD attrib, void *value, DWORD size);
extern fn bool bass_channelSet3DAttribute(uint handle,int mode,float min,float max,int iangle,int oangle,float outvol) @extern("BASS_ChannelSet3DAttributes");//BOOL BASSDEF(BASS_ChannelSet3DAttributes)(DWORD handle, int mode, float min, float max, int iangle, int oangle, float outvol);
extern fn bool bass_channelGet3DAttributes(uint handle,uint* mode,float* min,float* max,uint* iangle,uint* oangle,float* outvol) @extern("BASS_ChannelGet3DAttributes");//BOOL BASSDEF(BASS_ChannelGet3DAttributes)(DWORD handle, DWORD *mode, float *min, float *max, DWORD *iangle, DWORD *oangle, float *outvol);
extern fn bool bass_channelSEt3DPosition(uint handle,Bass_3DVector* pos,Bass_3DVector* orient,Bass_3DVector* vel) @extern("BASS_ChannelSet3DPosition");//BOOL BASSDEF(BASS_ChannelSet3DPosition)(DWORD handle, const BASS_3DVECTOR *pos, const BASS_3DVECTOR *orient, const BASS_3DVECTOR *vel);
extern fn bool bass_channelGet3DPositon(uint handle,Bass_3DVector* pos,Bass_3DVector* orient,Bass_3DVector* vel) @extern("BASS_ChannelGet3DPosition");// BOOL BASSDEF(BASS_ChannelGet3DPosition)(DWORD handle, BASS_3DVECTOR *pos, BASS_3DVECTOR *orient, BASS_3DVECTOR *vel);
extern fn long bass_channelGetLength(uint handle,uint mode) @extern("BASS_ChannelGetLength");//QWORD BASSDEF(BASS_ChannelGetLength)(DWORD handle, DWORD mode);
extern fn bool bass_channelSetPosition(uint handle,ulong pos,uint mode) @extern("BASS_ChannelSetPosition");//BOOL BASSDEF(BASS_ChannelSetPosition)(DWORD handle, QWORD pos, DWORD mode);
extern fn ulong bass_channelGetPosition(uint handle,uint mode) @extern("BASS_ChannelGetPosition");//QWORD BASSDEF(BASS_ChannelGetPosition)(DWORD handle, DWORD mode);
extern fn uint bass_channelGetLevel(uint handle) @extern("BASS_ChannelGetLevel");//DWORD BASSDEF(BASS_ChannelGetLevel)(DWORD handle);
extern fn bool bass_channelGetLevelEx(uint handle,float* levels,float length,uint flags) @extern("BASS_ChannelGetLevelEx");//BOOL BASSDEF(BASS_ChannelGetLevelEx)(DWORD handle, float *levels, float length, DWORD flags);
extern fn uint bass_channelGetData(uint handle,void* buffer,uint length) @extern("BASS_ChannelGetData");//DWORD BASSDEF(BASS_ChannelGetData)(DWORD handle, void *buffer, DWORD length);
extern fn uint bass_channelSetSync(uint handle,uint type,ulong parm,SyncProc* proc,void* user) @extern("BASS_ChannelSetSync");//HSYNC BASSDEF(BASS_ChannelSetSync)(DWORD handle, DWORD type, QWORD param, SYNCPROC *proc, void *user);
extern fn bool bass_channelRemoveSync(uint handle,uint sync) @extern("BASS_ChannelRemoveSync");//BOOL BASSDEF(BASS_ChannelRemoveSync)(DWORD handle, HSYNC sync);
extern fn bool bass_channelSetLink(uint handle,uint chan) @extern("BASS_ChannelSetLink");//BOOL BASSDEF(BASS_ChannelSetLink)(DWORD handle, DWORD chan);
extern fn bool bass_channelRemoveLink(uint handle,uint chan) @extern("BASS_ChannelRemoveLink");//BOOL BASSDEF(BASS_ChannelRemoveLink)(DWORD handle, DWORD chan);
extern fn uint bass_channelSetDSP(uint handle,DspProc* proc,void* user,int priority) @extern("BASS_ChannelSetDSP");//HDSP BASSDEF(BASS_ChannelSetDSP)(DWORD handle, DSPPROC *proc, void *user, int priority);
extern fn bool bass_channelRemoveDSP(uint handle,uint dsp) @extern("BASS_ChannelRemoveDSP");//BOOL BASSDEF(BASS_ChannelRemoveDSP)(DWORD handle, HDSP dsp);
extern fn void bass_channelSetFX(uint handle,uint type,int priority) @extern("BASS_ChannelSetFX");// BASSDEF(BASS_ChannelSetFX)(DWORD handle, DWORD type, int priority);
extern fn bool bass_channelRemoveFx(uint handle,uint fx) @extern("BASS_ChannelRemoveFX");//BOOL BASSDEF(BASS_ChannelRemoveFX)(DWORD handle, HFX fx);

extern fn bool bass_fxSetParameters(uint handle,void* params) @extern("BASS_FXSetParameters");//BOOL BASSDEF(BASS_FXSetParameters)(HFX handle, const void *params);
extern fn bool bass_fxGetParameters(uint handle,void* parames) @extern("BASS_FXGetParameters");//BOOL BASSDEF(BASS_FXGetParameters)(HFX handle, void *params);
extern fn bool bass_fxSetPriority(uint handle,int priority) @extern("BASS_FXSetPriority");//BOOL BASSDEF(BASS_FXSetPriority)(HFX handle, int priority);
extern fn bool bass_fxReset(uint handle) @extern("BASS_FXReset");//BOOL BASSDEF(BASS_FXReset)(DWORD handle);


fn uint bass_pluginLoad(WString file,uint flags)// BASS_PluginLoad(const WCHAR *file, DWORD flags)
{
    return bass_pluginLoad((WString)file,flags|BASS_UNICODE);//BASS_PluginLoad((const char*)file, flags | BASS_UNICODE);
}

fn uint bass_music_load(bool mem, WString file,ulong offset, uint length, uint flags, uint freq)
{
	return bass_musicLoad(mem,(void*)file,offset,length,flags|BASS_UNICODE,freq);//BASS_MusicLoad(mem, (const void*)file, offset, length, flags | BASS_UNICODE, freq);
}

fn uint bass_sample_load(bool mem,WString file,ulong offset,uint length,uint max,uint flags)// BASS_SampleLoad(BOOL mem, const WCHAR *file, QWORD offset, DWORD length, DWORD max, DWORD flags)
{
	return bass_sampleLoad(mem,(void*)file,offset,length,max,flags|BASS_UNICODE);//BASS_SampleLoad(mem, (const void*)file, offset, length, max, flags | BASS_UNICODE);
}

fn uint bass_stream_createFile(bool mem,WString file,ulong offset,ulong length,uint flags)//)) BASS_StreamCreateFile(BOOL mem, const WCHAR *file, QWORD offset, QWORD length, DWORD flags)
{
	return bass_streamCreateFile(mem,(void*)file,offset,length,flags|BASS_UNICODE);//BASS_StreamCreateFile(mem, (const void*)file, offset, length, flags | BASS_UNICODE);
}

fn uint bass_stream_createURL(WString url,uint offset,uint flags,DownloadProc* proc,void* user)//) BASS_StreamCreateURL(const WCHAR *url, DWORD offset, DWORD flags, DOWNLOADPROC *proc, void *user)
{
	return bass_streamCreateURL((ZString)url,offset,flags|BASS_UNICODE,proc,user);//BASS_StreamCreateURL((const char*)url, offset, flags | BASS_UNICODE, proc, user);
}

fn bool bass_set_configPtr(uint optin,WString value)//BASS_SetConfigPtr(DWORD option, const WCHAR *value)
{
	return bass_setConfigPtr(optin|BASS_UNICODE,(void*)value);//BASS_SetConfigPtr(option | BASS_UNICODE, (const void*)value);
}

