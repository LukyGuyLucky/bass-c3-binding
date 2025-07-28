/*  bass.h to bass.c3 binding,use at your own risk
*/

module bass;

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


// Error codes returned by ErrorGetCode
const OK				=0;	// all is OK
const ERROR_MEM		=1;	// memory error
const ERROR_FILEOPEN	=2;	// can't open the file
const ERROR_DRIVER	=3;	// can't find a free/valid driver
const ERROR_BUFLOST	=4;	// the sample buffer was lost
const ERROR_HANDLE	=5;	// invalid handle
const ERROR_FORMAT	=6;	// unsupported sample format
const ERROR_POSITION	=7;	// invalid position
const ERROR_INIT		=8;	// Init has not been successfully called
const ERROR_START	=9;	// Start has not been successfully called
const ERROR_SSL		=10;	// SSL/HTTPS support isn't available
const ERROR_REINIT	=11;	// device needs to be reinitialized
const ERROR_ALREADY	=14;	// already initialized/paused/whatever
const ERROR_NOTAUDIO	=17;	// file does not contain audio
const ERROR_NOCHAN	=18;	// can't get a free channel
const ERROR_ILLTYPE	=19;	// an illegal type was specified
const ERROR_ILLPARAM	=20;	// an illegal parameter was specified
const ERROR_NO3D		=21;	// no 3D support
const ERROR_NOEAX	=22;	// no EAX support
const ERROR_DEVICE	=23;	// illegal device number
const ERROR_NOPLAY	=24;	// not playing
const ERROR_FREQ		=25;	// illegal sample rate
const ERROR_NOTFILE	=27	;// the stream is not a file stream
const ERROR_NOHW		=29;	// no hardware voices available
const ERROR_EMPTY	=31;	// the file has no sample data
const ERROR_NONET	=32;	// no internet connection could be opened
const ERROR_CREATE	=33;	// couldn't create the file
const ERROR_NOFX		=34;	// effects are not available
const ERROR_NOTAVAIL	=37;	// requested data/action is not available
const ERROR_DECODE	=38;	// the channel is/isn't a "decoding channel"
const ERROR_DX		=39;	// a sufficient DirectX version is not installed
const ERROR_TIMEOUT	=40;	// connection timedout
const ERROR_FILEFORM	=41	;// unsupported file format
const ERROR_SPEAKER	=42;	// unavailable speaker
const ERROR_VERSION	=43;	// invalid BASS version (used by add-ons)
const ERROR_CODEC	=44;	// codec is not available/supported
const ERROR_ENDED	=45;	// the channel/file has ended
const ERROR_BUSY		=46;	// the device is busy
const ERROR_UNSTREAMABLE	=47;	// unstreamable file
const ERROR_PROTOCOL	=48;	// unsupported protocol
const ERROR_DENIED	=49;	// access denied
const ERROR_UNKNOWN	=-1;	// some other mystery problem

// SetConfig options
const CONFIG_BUFFER			=0;
const CONFIG_UPDATEPERIOD	=1;
const CONFIG_GVOL_SAMPLE		=4;
const CONFIG_GVOL_STREAM		=5;
const CONFIG_GVOL_MUSIC		=6;
const CONFIG_CURVE_VOL		=7;
const CONFIG_CURVE_PAN		=8;
const CONFIG_FLOATDSP		=9;
const CONFIG_3DALGORITHM		=10;
const CONFIG_NET_TIMEOUT		=11;
const CONFIG_NET_BUFFER		=12;
const CONFIG_PAUSE_NOPLAY	=13;
const CONFIG_NET_PREBUF		=15;
const CONFIG_NET_PASSIVE		=18;
const CONFIG_REC_BUFFER		=19;
const CONFIG_NET_PLAYLIST	=21;
const CONFIG_MUSIC_VIRTUAL	=22;
const CONFIG_VERIFY			=23;
const CONFIG_UPDATETHREADS	=24;
const CONFIG_DEV_BUFFER		=27;
const CONFIG_REC_LOOPBACK	=28;
const CONFIG_VISTA_TRUEPOS	=30;
const CONFIG_IOS_SESSION		=34;
const CONFIG_IOS_MIXAUDIO	=34;
const CONFIG_DEV_DEFAULT		=36;
const CONFIG_NET_READTIMEOUT	=37;
const CONFIG_VISTA_SPEAKERS	=38;
const CONFIG_IOS_SPEAKER		=39;
const CONFIG_MF_DISABLE		=40;
const CONFIG_UNICODE			=42;
const CONFIG_SRC_SAMPLE		=44;
const CONFIG_ASYNCFILE_BUFFER =45;
const CONFIG_OGG_PRESCAN		=47;
const CONFIG_MF_VIDEO		=48;
const CONFIG_AIRPLAY			=49;
const CONFIG_DEV_NONSTOP		=50;
const CONFIG_VERIFY_NET		=52;
const CONFIG_DEV_PERIOD		=53;
const CONFIG_FLOAT			=54;
const CONFIG_NET_SEEK		=56;
const CONFIG_AM_DISABLE		=58;
const CONFIG_NET_PLAYLIST_DEPTH	=59;
const CONFIG_NET_PREBUF_WAIT	=60;
const CONFIG_ANDROID_SESSIONID	=62;
const CONFIG_WASAPI_PERSIST	=65;
const CONFIG_ANDROID_AAUDIO	=67;
const CONFIG_SAMPLE_ONEHANDLE	=69;
const CONFIG_NET_META		=71;
const CONFIG_NET_RESTRATE	=72;
const CONFIG_REC_DEFAULT		=73;
const CONFIG_NORAMP			=74;

// SetConfigPtr options
const CONFIG_NET_AGENT		=16;
const CONFIG_NET_PROXY		=17;
const CONFIG_IOS_NOTIFY		=46;
const CONFIG_ANDROID_JAVAVM	=63;
const CONFIG_LIBSSL			=64;
const CONFIG_FILENAME		=75;

const CONFIG_THREAD			=0x40000000 ;// flag: thread-specific setting

// CONFIG_IOS_SESSION flags
const IOS_SESSION_MIX		=1;
const IOS_SESSION_DUCK		=2;
const IOS_SESSION_AMBIENT	=4;
const IOS_SESSION_SPEAKER	=8;
const IOS_SESSION_DISABLE	=16;
const IOS_SESSION_DEACTIVATE	=32;
const IOS_SESSION_AIRPLAY	=64;
const IOS_SESSION_BTHFP		=128;
const IOS_SESSION_BTA2DP		=0x100;

// Init flags
const DEVICE_8BITS		=1	;	// unused
const DEVICE_MONO		=2	;	// mono
const DEVICE_3D			=4	;	// unused
const DEVICE_16BITS		=8	;	// limit output to 16-bit
const DEVICE_REINIT		=128;		// reinitialize
const DEVICE_LATENCY		=0x100	;// unused
const DEVICE_CPSPEAKERS	=0x400;	// unused
const DEVICE_SPEAKERS	=0x800	;// force enabling of speaker assignment
const DEVICE_NOSPEAKER	=0x1000	;// ignore speaker arrangement
const DEVICE_DMIX		=0x2000	;// use ALSA "dmix" plugin
const DEVICE_FREQ		=0x4000	;// set device sample rate
const DEVICE_STEREO		=0x8000	;// limit output to stereo
const DEVICE_HOG			=0x10000;	// hog/exclusive mode
const DEVICE_AUDIOTRACK	=0x20000;	// use AudioTrack output
const DEVICE_DSOUND		=0x40000;	// use DirectSound output
const DEVICE_SOFTWARE	=0x80000;	// disable hardware/fastpath output

// DirectSound interfaces (for use with GetDSoundObject)
const OBJECT_DS		=1;	// IDirectSound
const OBJECT_DS3DL	=2	;// IDirectSound3DListener

// Device info structure
struct Bass_DeviceInfo{

	ZString name;	// description
	ZString driver;	// driver

	uint flags;
} 


// DEVICEINFO flags
const DEVICE_ENABLED	=1;
const DEVICE_DEFAULT		=2;
const DEVICE_INIT		=4;
const DEVICE_LOOPBACK	=8;
const DEVICE_DEFAULTCOM	=128;

const DEVICE_TYPE_MASK			=0xff000000;
const DEVICE_TYPE_NETWORK		=0x01000000;
const DEVICE_TYPE_SPEAKERS		=0x02000000;
const DEVICE_TYPE_LINE			=0x03000000;
const DEVICE_TYPE_HEADPHONES		=0x04000000;
const DEVICE_TYPE_MICROPHONE		=0x05000000;
const DEVICE_TYPE_HEADSET		=0x06000000;
const DEVICE_TYPE_HANDSET		=0x07000000;
const DEVICE_TYPE_DIGITAL		=0x08000000;
const DEVICE_TYPE_SPDIF			=0x09000000;
const DEVICE_TYPE_HDMI			=0x0a000000;
const DEVICE_TYPE_DISPLAYPORT	=0x40000000;

// GetDeviceInfo flags
const DEVICES_AIRPLAY	=0x1000000;

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


const SAMPLE_8BITS		=1	;// 8 bit
const SAMPLE_FLOAT		=256;	// 32 bit floating-point
const SAMPLE_MONO		=2	;// mono
const SAMPLE_LOOP		=4	;// looped
const SAMPLE_3D			=8;	// 3D functionality
const SAMPLE_SOFTWARE	=16	;// unused
const SAMPLE_MUTEMAX		=32	;// mute at max distance (3D only)
const SAMPLE_VAM			=64	;// unused
const SAMPLE_FX			=128;	// unused
const SAMPLE_OVER_VOL	=0x10000;	// override lowest volume
const SAMPLE_OVER_POS	=0x20000;	// override longest playing
const SAMPLE_OVER_DIST	=0x30000; // override furthest from listener (3D only)

const STREAM_PRESCAN		=0x20000 ;// scan file for accurate seeking and length
const STREAM_AUTOFREE	=0x40000;	// automatically free the stream when it stops/ends
const STREAM_RESTRATE	=0x80000;	// restrict the download rate of internet file stream
const STREAM_BLOCK		=0x100000; // download internet file stream in small blocks
const STREAM_DECODE		=0x200000 ;// don't play the stream, only decode
const STREAM_STATUS		=0x800000; // give server status info (HTTP/ICY tags) in DOWNLOADPROC

const MP3_IGNOREDELAY	=0x200; // ignore LAME/Xing/VBRI/iTunes delay & padding info
const MP3_SETPOS			=STREAM_PRESCAN;

const MUSIC_FLOAT		=SAMPLE_FLOAT;
const MUSIC_MONO			=SAMPLE_MONO;
const MUSIC_LOOP			=SAMPLE_LOOP;
const MUSIC_3D			=SAMPLE_3D;
const MUSIC_FX			=SAMPLE_FX;
const MUSIC_AUTOFREE		=STREAM_AUTOFREE;
const MUSIC_DECODE		=STREAM_DECODE;
const MUSIC_PRESCAN		=STREAM_PRESCAN;	// calculate playback length
const MUSIC_CALCLEN		=MUSIC_PRESCAN;
const MUSIC_RAMP			=0x200;	// normal ramping
const MUSIC_RAMPS		=0x400;	// sensitive ramping
const MUSIC_SURROUND		=0x800;	// surround sound
const MUSIC_SURROUND2	=0x1000;	// surround sound (mode 2)
const MUSIC_FT2PAN		=0x2000	;// apply FastTracker 2 panning to XM files
const MUSIC_FT2MOD		=0x2000;	// play .MOD as FastTracker 2 does
const MUSIC_PT1MOD		=0x4000	;// play .MOD as ProTracker 1 does
const MUSIC_NONINTER		=0x10000;	// non-interpolated sample mixing
const MUSIC_SINCINTER	=0x800000 ;// sinc interpolated sample mixing
const MUSIC_POSRESET		=0x8000;	// stop all notes when moving position
const MUSIC_POSRESETEX	=0x400000; // stop all notes and reset bmp/etc when moving position
const MUSIC_STOPBACK		=0x80000;	// stop the music on a backwards jump effect
const MUSIC_NOSAMPLE		=0x100000 ;// don't load the samples

// Speaker assignment flags
const SPEAKER_FRONT		=0x1000000;	// front speakers
const SPEAKER_REAR		=0x2000000;	// rear speakers
const SPEAKER_CENLFE		=0x3000000;	// center & LFE speakers (5.1)
const SPEAKER_SIDE		=0x4000000;	// side speakers (7.1)
macro bass_speaker_n(n)=>((n)<<24);//const SPEAKER_N(n)		=((n)<<24);	// n'th pair of speakers (max 15)
const SPEAKER_LEFT		=0x10000000;	// modifier: left
const SPEAKER_RIGHT		=0x20000000	;// modifier: right
const SPEAKER_FRONTLEFT	=SPEAKER_FRONT | SPEAKER_LEFT;
const SPEAKER_FRONTRIGHT	=SPEAKER_FRONT | SPEAKER_RIGHT;
const SPEAKER_REARLEFT	=SPEAKER_REAR | SPEAKER_LEFT;
const SPEAKER_REARRIGHT	=SPEAKER_REAR | SPEAKER_RIGHT;
const SPEAKER_CENTER		=SPEAKER_CENLFE | SPEAKER_LEFT;
const SPEAKER_LFE		=SPEAKER_CENLFE | SPEAKER_RIGHT;
const SPEAKER_SIDELEFT	=SPEAKER_SIDE | SPEAKER_LEFT;
const SPEAKER_SIDERIGHT	=SPEAKER_SIDE | SPEAKER_RIGHT;
const SPEAKER_REAR2		=SPEAKER_SIDE;
const SPEAKER_REAR2LEFT	=SPEAKER_SIDELEFT;
const SPEAKER_REAR2RIGHT	=SPEAKER_SIDERIGHT;

const ASYNCFILE			=0x40000000	;// read file asynchronously
const UNICODE			=0x80000000	;// UTF-16

const RECORD_ECHOCANCEL	=0x2000;
const RECORD_AGC			=0x4000;
const RECORD_PAUSE		=0x8000	;// start recording paused

// DX7 voice allocation & management flags
const VAM_HARDWARE		=1;
const VAM_SOFTWARE		=2;
const VAM_TERM_TIME		=4;
const VAM_TERM_DIST		=8;
const VAM_TERM_PRIO	=16;

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


const ORIGRES_FLOAT	=0x10000;

// CHANNELINFO types
const CTYPE_SAMPLE	=1;
const CTYPE_RECORD		=2;
const CTYPE_STREAM		=0x10000;
const CTYPE_STREAM_VORBIS	=0x10002;
const CTYPE_STREAM_OGG	=0x10002;
const CTYPE_STREAM_MP1	=0x10003;
const CTYPE_STREAM_MP2	=0x10004;
const CTYPE_STREAM_MP3	=0x10005;
const CTYPE_STREAM_AIFF	=0x10006;
const CTYPE_STREAM_CA	=0x10007;
const CTYPE_STREAM_MF	=0x10008;
const CTYPE_STREAM_AM	=0x10009;
const CTYPE_STREAM_SAMPLE	=0x1000a;
const CTYPE_STREAM_DUMMY		=0x18000;
const CTYPE_STREAM_DEVICE	=0x18001;
const CTYPE_STREAM_WAV	=0x40000 ;// WAVE flag (LOWORD=codec)
const CTYPE_STREAM_WAV_PCM	=0x50001;
const CTYPE_STREAM_WAV_FLOAT	=0x50003;
const CTYPE_MUSIC_MOD	=0x20000;
const CTYPE_MUSIC_MTM	=0x20001;
const CTYPE_MUSIC_S3M	=0x20002;
const CTYPE_MUSIC_XM		=0x20003;
const CTYPE_MUSIC_IT		=0x20004;
const CTYPE_MUSIC_MO3	=0x00100 ;// MO3 flag

// PluginLoad flags
const PLUGIN_PROC		=1;


struct Bass_PluginForm{
	uint ctype;		// channel type

	ZString name;	// format description
	ZString exts;	// file extension filter (*.ext1;*.ext2;etc...)

} 

struct Bass_PluginInfo{
	uint version;					// version (same form as GetVersion)
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

// software 3D mixing algorithms (used with CONFIG_3DALGORITHM)
const BASS_3DALG_DEFAULT	=0;
const BASS_3DALG_OFF		=1;
const BASS_3DALG_FULL		=2;
const BASS_3DALG_LIGHT	=3;

// SampleGetChannel flags
const SAMCHAN_NEW		=1;	// get a new playback channel
const SAMCHAN_STREAM		=2;	// create a stream

alias StreamProc=fn ulong (uint handle, void *buffer, uint length, void *user);
/* User stream callback function.
handle : The stream that needs writing
buffer : Buffer to write the samples in
length : Number of bytes to write
user   : The 'user' parameter value given when calling BASS_StreamCreate
RETURN : Number of bytes written. Set the BASS_STREAMPROC_END flag to end the stream. */

const STREAMPROC_END		=0x80000000;	// end of user stream flag

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
alias FileCloseProc= fn void (void *user);
alias FileLenProc=fn ulong(void *user);
alias FileReadProc=fn uint(void *buffer, uint length, void *user);
alias FileSeekProc=fn bool(ulong offset, void *user);

struct Bass_FileProc{
	FileCloseProc *close;
	FileLenProc *length;
	FileReadProc *read;
	FileSeekProc *seek;
} 


// BASS_StreamPutFileData options
const FILEDATA_END		=0;	// end & close the file

// StreamGetFilePosition modes
const FILEPOS_CURRENT	=0;
const FILEPOS_DECODE		=FILEPOS_CURRENT;
const FILEPOS_DOWNLOAD	=1;
const FILEPOS_END		=2;
const FILEPOS_START		=3;
const FILEPOS_CONNECTED	=4;
const FILEPOS_BUFFER		=5;
const FILEPOS_SOCKET		=6;
const FILEPOS_ASYNCBUF	=7;
const FILEPOS_SIZE		=8;
const FILEPOS_BUFFERING	=9;
const FILEPOS_AVAILABLE	=10;

alias DownloadProc=fn  void(void *buffer, uint length, void *user);
/* Internet stream download callback function.
buffer : Buffer containing the downloaded data... NULL=end of download
length : Number of bytes in the buffer
user   : The 'user' parameter value given when calling StreamCreateURL */

// ChannelSetSync types
const SYNC_POS			=0;
const SYNC_END			=2;
const SYNC_META			=4;
const SYNC_SLIDE			=5;
const SYNC_STALL			=6;
const SYNC_DOWNLOAD		=7;
const SYNC_FREE			=8;
const SYNC_SETPOS		=11;
const SYNC_MUSICPOS		=10;
const SYNC_MUSICINST		=1;
const SYNC_MUSICFX		=3;
const SYNC_OGG_CHANGE	=12;
const SYNC_DEV_FAIL		=14;
const SYNC_DEV_FORMAT	=15;
const SYNC_THREAD		=0x20000000	;// flag: call sync in other thread
const SYNC_MIXTIME		=0x40000000	;// flag: sync at mixtime, else at playtime
const SYNC_ONETIME		=0x80000000;	// flag: sync only once, else continuously


alias SyncProc=fn void(uint handle, uint channel, uint data, void *user);
/* Sync callback function.
handle : The sync that has occured
channel: Channel that the sync occured in
data   : Additional data associated with the sync's occurance
user   : The 'user' parameter given when calling ChannelSetSync */

alias DspProc=fn void(uint handle, uint channel, void *buffer, uint length, void *user);
/* DSP callback function.
handle : The DSP handle
channel: Channel that the DSP is being applied to
buffer : Buffer to apply the DSP to
length : Number of bytes in the buffer
user   : The 'user' parameter given when calling ChannelSetDSP */

alias RecordProc=fn bool(uint handle,void *buffer, uint length, void *user);
/* Recording callback function.
handle : The recording handle
buffer : Buffer containing the recorded sample data
length : Number of bytes
user   : The 'user' parameter value given when calling RecordStart
RETURN : TRUE = continue recording, FALSE = stop */


// ChannelIsActive return values
const ACTIVE_STOPPED			=0;
const ACTIVE_PLAYING			=1;
const ACTIVE_STALLED			=2;
const ACTIVE_PAUSED			=3;
const ACTIVE_PAUSED_DEVICE	=4;

// Channel attributes
const ATTRIB_FREQ			=1;
const ATTRIB_VOL				=2;
const ATTRIB_PAN				=3;
const ATTRIB_EAXMIX			=4;
const ATTRIB_NOBUFFER		=5;
const ATTRIB_VBR				=6;
const ATTRIB_CPU				=7;
const ATTRIB_SRC				=8;
const ATTRIB_NET_RESUME		=9;
const ATTRIB_SCANINFO		=10;
const ATTRIB_BITRATE			=12;
const ATTRIB_BUFFER			=13;
const ATTRIB_GRANULE			=14;
const ATTRIB_USER			=15;
const ATTRIB_TAIL			=16;
const ATTRIB_PUSH_LIMIT		=17;
const ATTRIB_DOWNLOADPROC	=18;
const ATTRIB_VOLDSP			=19;
const ATTRIB_VOLDSP_PRIORITY	=20;
const ATTRIB_MUSIC_AMPLIFY	=0x100;
const ATTRIB_MUSIC_PANSEP	=0x101;
const ATTRIB_MUSIC_PSCALER	=0x102;
const ATTRIB_MUSIC_BPM		=0x103;
const ATTRIB_MUSIC_SPEED		=0x104;
const ATTRIB_MUSIC_VOL_GLOBAL =0x105;
const ATTRIB_MUSIC_ACTIVE	=0x106;
const ATTRIB_MUSIC_VOL_CHAN	=0x200 ;// + channel #
const ATTRIB_MUSIC_VOL_INST	=0x300 ;// + instrument #

// ChannelSlideAttribute flags
const SLIDE_LOG				=0x1000000;

// ChannelGetData flags
const DATA_AVAILABLE	=0		;	// query how much data is buffered
const DATA_NOREMOVE	=0x10000000	;// flag: don't remove data from recording buffer
const DATA_FIXED		=0x20000000;	// unused
const DATA_FLOAT		=0x40000000	;// flag: return floating-point sample data
const DATA_FFT256	=0x80000000	;// 256 sample FFT
const DATA_FFT512	=0x80000001	;// 512 FFT
const DATA_FFT1024	=0x80000002	;// 1024 FFT
const DATA_FFT2048	=0x80000003	;// 2048 FFT
const DATA_FFT4096	=0x80000004	;// 4096 FFT
const DATA_FFT8192	=0x80000005	;// 8192 FFT
const DATA_FFT16384	=0x80000006	;// 16384 FFT
const DATA_FFT32768	=0x80000007;	// 32768 FFT
const DATA_FFT_INDIVIDUAL =0x10;	// FFT flag: FFT for each channel, else all combined
const DATA_FFT_NOWINDOW	=0x20;	// FFT flag: no Hanning window
const DATA_FFT_REMOVEDC	=0x40;	// FFT flag: pre-remove DC bias
const DATA_FFT_COMPLEX	=0x80	;// FFT flag: return complex data
const DATA_FFT_NYQUIST	=0x100;	// FFT flag: return extra Nyquist value

// ChannelGetLevelEx flags
const LEVEL_MONO		=1;	// get mono level
const LEVEL_STEREO	=2	;// get stereo level
const LEVEL_RMS		=4;	// get RMS levels
const LEVEL_VOLPAN	=8;	// apply VOL/PAN attributes to the levels
const LEVEL_NOREMOVE	=16;	// don't remove data from recording buffer

// ChannelGetTags types : what's returned
const TAG_ID3		=0;	// ID3v1 tags : TAG_ID3 structure
const TAG_ID3V2		=1	;// ID3v2 tags : variable length block
const TAG_OGG		=2	;// OGG comments : series of null-terminated UTF-8 strings
const TAG_HTTP		=3	;// HTTP headers : series of null-terminated ASCII strings
const TAG_ICY		=4	;// ICY headers : series of null-terminated ANSI strings
const TAG_META		=5;	// ICY metadata : ANSI string
const TAG_APE		=6	;// APE tags : series of null-terminated UTF-8 strings
const TAG_MP4 		=7	;// MP4/iTunes metadata : series of null-terminated UTF-8 strings
const TAG_WMA		=8;	// WMA tags : series of null-terminated UTF-8 strings
const TAG_VENDOR		=9;	// OGG encoder : UTF-8 string
const TAG_LYRICS3	=10;	// Lyric3v2 tag : ASCII string
const TAG_CA_CODEC	=11;	// CoreAudio codec info : TAG_CA_CODEC structure
const TAG_MF			=13;	// Media Foundation tags : series of null-terminated UTF-8 strings
const TAG_WAVEFORMAT	=14	;// WAVE format : WAVEFORMATEEX structure
const TAG_AM_NAME	=16	;// Android Media codec name : ASCII string
const TAG_ID3V2_2	=17;	// ID3v2 tags (2nd block) : variable length block
const TAG_AM_MIME	=18	;// Android Media MIME type : ASCII string
const TAG_LOCATION	=19	;// redirected URL : ASCII string
const TAG_RIFF_INFO	=0x100 ;// RIFF "INFO" tags : series of null-terminated ANSI strings
const TAG_RIFF_BEXT	=0x101 ;// RIFF/BWF "bext" tags : TAG_BEXT structure
const TAG_RIFF_CART	=0x102 ;// RIFF/BWF "cart" tags : TAG_CART structure
const TAG_RIFF_DISP	=0x103; // RIFF "DISP" text tag : ANSI string
const TAG_RIFF_CUE	=0x104; // RIFF "cue " chunk : TAG_CUE structure
const TAG_RIFF_SMPL	=0x105 ;// RIFF "smpl" chunk : TAG_SMPL structure
const TAG_APE_BINARY	=0x1000;	// + index #, binary APE tag : TAG_APE_BINARY structure
const TAG_MUSIC_NAME		=0x10000;	// MOD music name : ANSI string
const TAG_MUSIC_MESSAGE	=0x10001;	// MOD message : ANSI string
const TAG_MUSIC_ORDERS	=0x10002;	// MOD order list : BYTE array of pattern numbers
const TAG_MUSIC_AUTH		=0x10003;	// MOD author : UTF-8 string
const TAG_MUSIC_INST		=0x10100;	// + instrument #, MOD instrument name : ANSI string
const TAG_MUSIC_CHAN		=0x10200;	// + channel #, MOD channel name : ANSI string
const TAG_MUSIC_SAMPLE	=0x10300;	// + sample #, MOD sample name : ANSI string



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

// ChannelGetLength/GetPosition/SetPosition modes
const POS_BYTE			=0	;	// byte position
const POS_MUSIC_ORDER	=1	;	// order.row position, MAKELONG(order,row)
const POS_OGG			=3	;	// OGG bitstream number
const POS_END			=0x10;	// trimmed end position
const POS_LOOP			=0x11;	// loop start positiom
const POS_FLUSH			=0x1000000 ;// flag: flush decoder/FX buffers
const POS_RESET			=0x2000000; // flag: reset user file buffers
const POS_RELATIVE		=0x4000000; // flag: seek relative to the current position
const POS_INEXACT		=0x8000000; // flag: allow seeking to inexact position
const POS_DECODE			=0x10000000 ;// flag: get the decoding (not playing) position
const POS_DECODETO		=0x20000000 ;// flag: decode to the position instead of seeking
const POS_SCAN			=0x40000000; // flag: scan to the position

// ChannelSetDevice/GetDevice option
const NODEVICE		=0x20000;

// RecordSetInput flags
const INPUT_OFF		=0x10000;
const INPUT_ON		=0x20000;

const INPUT_TYPE_MASK		=0xff000000;
const INPUT_TYPE_UNDEF		=0x00000000;
const INPUT_TYPE_DIGITAL		=0x01000000;
const INPUT_TYPE_LINE		=0x02000000;
const INPUT_TYPE_MIC			=0x03000000;
const INPUT_TYPE_SYNTH		=0x04000000;
const INPUT_TYPE_CD			=0x05000000;
const INPUT_TYPE_PHONE		=0x06000000;
const INPUT_TYPE_SPEAKER		=0x07000000;
const INPUT_TYPE_WAVE		=0x08000000;
const INPUT_TYPE_AUX			=0x09000000;
const INPUT_TYPE_ANALOG		=0x0a000000;

// ChannelSetFX effect types
const FX_DX8_CHORUS			=0;
const FX_DX8_COMPRESSOR		=1;
const FX_DX8_DISTORTION		=2;
const FX_DX8_ECHO			=3;
const FX_DX8_FLANGER			=4;
const FX_DX8_GARGLE			=5;
const FX_DX8_I3DL2REVERB		=6;
const FX_DX8_PARAMEQ			=7;
const FX_DX8_REVERB		=8;
const FX_VOLUME				=9;

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

const DX8_PHASE_NEG_180       = 0;
const DX8_PHASE_NEG_90        = 1;
const DX8_PHASE_ZERO           =2;
const DX8_PHASE_90            = 3;
const DX8_PHASE_180           = 4;

struct Bass_FX_Volume_Param{
	float fTarget;
	float fCurrent;
	float fTime;
	uint lCurve;
} 

alias IosNotifyProc=fn void(uint status);
/* iOS notification callback function.
status : The notification (BASS_IOSNOTIFY_xxx) */

const IOSNOTIFY_INTERRUPT		=1;	// interruption started
const IOSNOTIFY_INTERRUPT_END	=2;	// interruption ended

extern fn bool setConfig(uint option,uint value) @extern("BASS_SetConfig");//BOOL BASSDEF(BASS_SetConfig)(DWORD option, DWORD value);
extern fn bool getConfig(uint option) @extern("BASS_GetConfig");//DWORD BASSDEF(BASS_GetConfig)(DWORD option);
extern fn bool setConfigPtr(uint option,void* value) @extern("BASS_SetConfigPtr");//BOOL BASSDEF(BASS_SetConfigPtr)(DWORD option, const void *value);
extern fn void* getConfigPtr(uint option) @extern("BASS_GetConfigPtr");
extern fn uint getVersion() @extern("BASS_GetVersion") ;//DWORD BASSDEF(BASS_GetVersion)(void);
extern fn int errorGetCode() @extern("BASS_ErrorGetCode");//BASSDEF(BASS_ErrorGetCode)(void);

extern fn bool getDeviceInfo(uint device,Bass_DeviceInfo* info) @extern("BASS_GetDeviceInfo");//BOOL BASSDEF(BASS_GetDeviceInfo)(DWORD device, BASS_DEVICEINFO *info);
//#if defined(_WIN32) && !defined(_WIN32_WCE) && !(defined(WINAPI_FAMILY) && WINAPI_FAMILY != WINAPI_FAMILY_DESKTOP_APP)
//BOOL BASSDEF(BASS_Init)(int device, DWORD freq, DWORD flags, HWND win, const void *dsguid);
//#else
extern fn bool init(int device,uint freq,uint flags,void* win,void* dsguid) @extern("BASS_Init");//BOOL BASSDEF(BASS_Init)(int device, DWORD freq, DWORD flags, void *win, const void *dsguid);
//#endif
extern fn bool free() @extern("BASS_Free");//BOOL BASSDEF(BASS_Free)(void);
extern fn bool setDevice(uint device) @extern("BASS_SetDevice");//BOOL BASSDEF(BASS_SetDevice)(DWORD device);
extern fn uint getDevice() @extern("BASS_GetDevice");//DWORD BASSDEF(BASS_GetDevice)(void);
extern fn bool getInfo(Bass_Info* info) @extern("BASS_GetInfo");//BOOL BASSDEF(BASS_GetInfo)(BASS_INFO *info);
extern fn bool start() @extern("BASS_Start");//BOOL BASSDEF(BASS_Start)(void);
extern fn bool stop() @extern("BASS_Stop");//BOOL BASSDEF(BASS_Stop)(void);
extern fn bool pause() @extern("BASS_Pause");//BOOL BASSDEF(BASS_Pause)(void);
extern fn uint isStarted() @extern("BASS_IsStarted");//DWORD BASSDEF(BASS_IsStarted)(void);
extern fn bool update(uint length) @extern("BASS_Update");//BOOL BASSDEF(BASS_Update)(DWORD length);
extern fn float getCPU() @extern("BASS_GetCPU");// BASSDEF(BASS_GetCPU)(void);
extern fn bool setVolume(float volume) @extern("BASS_SetVolume");//BOOL BASSDEF(BASS_SetVolume)(float volume);
extern fn float getVolume() @extern("BASS_GetVolume");//BASSDEF(BASS_GetVolume)(void);
//#if defined(_WIN32) && !defined(_WIN32_WCE) && !(defined(WINAPI_FAMILY) && WINAPI_FAMILY != WINAPI_FAMILY_DESKTOP_APP)
extern fn void* getDSoundObject(uint object) @extern("BASS_GetDSoundObject");//BASSDEF(BASS_GetDSoundObject)(DWORD object);
//#endif

extern fn bool set3DFactors(float distf,float rollf,float doppf) @extern("BASS_Set3DFactors");//BOOL BASSDEF(BASS_Set3DFactors)(float distf, float rollf, float doppf);
extern fn bool get3DFactors(float* disf,float* rollf,float* doppf) @extern("BASS_Get3DFactors");//BOOL BASSDEF(BASS_Get3DFactors)(float *distf, float *rollf, float *doppf);
extern fn bool set3DPosition(Bass_3DVector* pos,Bass_3DVector* vel,Bass_3DVector* front,Bass_3DVector* top) @extern("BASS_Set3DPosition");//BOOL BASSDEF(BASS_Set3DPosition)(const BASS_3DVECTOR *pos, const BASS_3DVECTOR *vel, const BASS_3DVECTOR *front, const BASS_3DVECTOR *top);
extern fn bool get3DPositon(Bass_3DVector* pos,Bass_3DVector* vel,Bass_3DVector* front,Bass_3DVector* top) @extern("BASS_Get3DPosition");//BOOL BASSDEF(BASS_Get3DPosition)(BASS_3DVECTOR *pos, BASS_3DVECTOR *vel, BASS_3DVECTOR *front, BASS_3DVECTOR *top);
extern fn void apply3D();//BASSDEF(BASS_Apply3D)(void);

extern fn uint pluinLoad(ZString file,uint flags) @extern("BASS_PluginLoad");//HPLUGIN BASSDEF(BASS_PluginLoad)(ZString file, DWORD flags);
extern fn bool pluginFree(uint handle) @extern("BASS_PluginFree");//BOOL BASSDEF(BASS_PluginFree)(HPLUGIN handle);
extern fn bool pluginEnable(uint handle,bool enable) @extern("BASS_PluginEnable");//BOOL BASSDEF(BASS_PluginEnable)(HPLUGIN handle, BOOL enable);
extern fn Bass_PluginInfo* pluginGetInfo(uint handle) @extern("BASS_PluginGetInfo");//const BASS_PLUGININFO *BASSDEF(BASS_PluginGetInfo)(HPLUGIN handle);

extern fn uint sampleLoad(bool mem,void* file,ulong offse,uint length,uint max,uint flags) @extern("BASS_SampleLoad");//HSAMPLE BASSDEF(BASS_SampleLoad)(BOOL mem, const void *file, QWORD offset, DWORD length, DWORD max, DWORD flags);
extern fn uint sampleCreate(uint length,uint freq,uint chans,uint max,uint flags) @extern("BASS_SampleCreate");//HSAMPLE BASSDEF(BASS_SampleCreate)(DWORD length, DWORD freq, DWORD chans, DWORD max, DWORD flags);
extern fn bool sampleFree(uint handle) @extern("BASS_SampleFree");//BOOL BASSDEF(BASS_SampleFree)(HSAMPLE handle);
extern fn bool sampleSetData(uint handle,void* buffer) @extern("BASS_SampleSetData");//BOOL BASSDEF(BASS_SampleSetData)(HSAMPLE handle, const void *buffer);
extern fn bool sampleGetData(uint handle,void* buffer) @extern("BASS_SampleGetData");//BOOL BASSDEF(BASS_SampleGetData)(HSAMPLE handle, void *buffer);
extern fn bool sampleGetInfo(uint handle,Bass_Sample* info) @extern("BASS_SampleGetInfo");//BOOL BASSDEF(BASS_SampleGetInfo)(HSAMPLE handle, BASS_SAMPLE *info);
extern fn bool sampleSetInfo(uint handle,Bass_Sample* info) @extern("BASS_SampleSetInfo");//BOOL BASSDEF(BASS_SampleSetInfo)(HSAMPLE handle, const BASS_SAMPLE *info);
extern fn uint sampleGetChannel(uint handle,uint flags) @extern("BASS_SampleGetChanel");//DWORD BASSDEF(BASS_SampleGetChannel)(HSAMPLE handle, DWORD flags);
extern fn uint sampleGetChannels(uint handle,uint* channels) @extern("BASS_SampleGetChannels");//DWORD BASSDEF(BASS_SampleGetChannels)(HSAMPLE handle, HCHANNEL *channels);
extern fn bool sampleStop(uint handle) @extern("BASS_SampleStop");//BOOL BASSDEF(BASS_SampleStop)(HSAMPLE handle);

extern fn uint streamCreate(uint freq,uint chans,uint flags,StreamProc* proc,void* user) @extern("BASS_StreamCreate");//HSTREAM BASSDEF(BASS_StreamCreate)(DWORD freq, DWORD chans, DWORD flags, STREAMPROC *proc, void *user);
extern fn uint streamCreateFile(bool mem,void* file,ulong offset,ulong length,uint flags) @extern("BASS_StreamCreateFile");//HSTREAM BASSDEF(BASS_StreamCreateFile)(BOOL mem, const void *file, QWORD offset, QWORD length, DWORD flags);
extern fn uint streamCreateURL(ZString rul,uint offset,uint flags,DownloadProc* proc,void* user) @extern("BASS_StreamCreateURL");//HSTREAM BASSDEF(BASS_StreamCreateURL)(ZString url, DWORD offset, DWORD flags, DOWNLOADPROC *proc, void *user);
extern fn uint streamCreateFileUser(uint system,uint flags,Bass_FileProc* proc,void* user) @extern("BASS_StreamCreateFileUser");//HSTREAM BASSDEF(BASS_StreamCreateFileUser)(DWORD system, DWORD flags, const BASS_FILEPROCS *proc, void *user);
extern fn bool streamFree(uint handle) @extern("BASS_StreamFree");//BOOL BASSDEF(BASS_StreamFree)(HSTREAM handle) ;
extern fn ulong streamGetFilePosition(uint handle,uint mode) @extern("BASS_StreamGetFilePosition");//QWORD BASSDEF(BASS_StreamGetFilePosition)(HSTREAM handle, DWORD mode);
extern fn uint streamPutData(uint handle,void* buffer,uint length) @extern("BASS_StreamPutData");//DWORD BASSDEF(BASS_StreamPutData)(HSTREAM handle, const void *buffer, DWORD length);
extern fn uint streamPutFileData(uint handle,void* buffer,uint length) @extern("BASS_StreamPutFileData");//DWORD BASSDEF(BASS_StreamPutFileData)(HSTREAM handle, const void *buffer, DWORD length);

extern fn uint musicLoad(bool mem,void* file,ulong offse,uint length,uint flags,uint freq) @extern("BASS_MusicLoad");//HMUSIC BASSDEF(BASS_MusicLoad)(BOOL mem, const void *file, QWORD offset, DWORD length, DWORD flags, DWORD freq);
extern fn bool musicFree(uint handle) @extern("BASS_MusicFree");//BOOL BASSDEF(BASS_MusicFree)(HMUSIC handle);

extern fn bool recordGetDeviceInfo(uint device,Bass_DeviceInfo* info) @extern("BASS_RecordGetDeviceInfo");//BOOL BASSDEF(BASS_RecordGetDeviceInfo)(DWORD device, BASS_DEVICEINFO *info);
extern fn bool recordInit(int device) @extern("BASS_RecordInit");//BOOL BASSDEF(BASS_RecordInit)(int device);
extern fn bool recordFree() @extern("BASS_RecordFree");//BOOL BASSDEF(BASS_RecordFree)(void);
extern fn bool recordSetDevice(uint device) @extern("BASS_RecordSetDevice");//BOOL BASSDEF(BASS_RecordSetDevice)(DWORD device);
extern fn uint recordGetDevice() @extern("BASS_RecordGetDevice");//DWORD BASSDEF(BASS_RecordGetDevice)(void);
extern fn bool recordGetInfo(Bass_RecordInfo* info) @extern("BASS_RecordGetInfo");//BOOL BASSDEF(BASS_RecordGetInfo)(BASS_RECORDINFO *info);
extern fn ZString recordGetInputName(int input) @extern("BASS_RecordGetInputName");//BASSDEF(BASS_RecordGetInputName)(int input);
extern fn bool recordSetInput(int input,uint flags,float volume) @extern("BASS_RecordSetInput");//BOOL BASSDEF(BASS_RecordSetInput)(int input, DWORD flags, float volume);
extern fn uint recordGetInput(int input,float* volume) @extern("BASS_RecordGetInput");//DWORD BASSDEF(BASS_RecordGetInput)(int input, float *volume);
extern fn uint recordStart(uint freq,uint chans,uint flags,RecordProc* proc,void* user) @extern("BASS_RecordStart");//HRECORD BASSDEF(BASS_RecordStart)(DWORD freq, DWORD chans, DWORD flags, RECORDPROC *proc, void *user);

extern fn double channelBytes2Seconds(uint handle,ulong pos) @extern("BASS_ChannelBytes2Seconds");//BASSDEF(BASS_ChannelBytes2Seconds)(DWORD handle, QWORD pos);
extern fn ulong channelSeconds2Bytes(uint handle,double pos) @extern("BASS_ChannelSeconds2Bytes");//QWORD BASSDEF(BASS_ChannelSeconds2Bytes)(DWORD handle, double pos);
extern fn uint channelGetDevice(uint handle) @extern("BASS_ChannelGetDevice");//DWORD BASSDEF(BASS_ChannelGetDevice)(DWORD handle);
extern fn bool channelSetDevice(uint handle,uint device) @extern("BASS_ChannelSetDevice");//BOOL BASSDEF(BASS_ChannelSetDevice)(DWORD handle, DWORD device);
extern fn uint channelIsActive(uint handle) @extern("BASS_ChannelIsActive");//DWORD BASSDEF(BASS_ChannelIsActive)(DWORD handle);
extern fn bool channelGetInfo(uint handle,Bass_ChannelInfo* info) @extern("BASS_ChannelGetInfo");//BOOL BASSDEF(BASS_ChannelGetInfo)(DWORD handle, BASS_CHANNELINFO *info);
extern fn ZString channelGetTags(uint handle,uint tags) @extern("BASS_ChannelGetTags");//BASSDEF(BASS_ChannelGetTags)(DWORD handle, DWORD tags);
extern fn uint channelFlags(uint handle,uint flags,uint mask) @extern("BASS_ChannelFlags");//DWORD BASSDEF(BASS_ChannelFlags)(DWORD handle, DWORD flags, DWORD mask);
extern fn bool channelLock(uint handle,bool lock) @extern("BASS_ChannelLock");//BOOL BASSDEF(BASS_ChannelLock)(DWORD handle, BOOL lock);
extern fn bool channelFree(uint handle) @extern("BASS_ChannelFree");//BOOL BASSDEF(BASS_ChannelFree)(DWORD handle);
extern fn bool channelPlay(uint handle,bool restart) @extern("BASS_ChannelPlay");//BOOL BASSDEF(BASS_ChannelPlay)(DWORD handle, BOOL restart);
extern fn bool channelStart(uint handle) @extern("BASS_ChannelStart");//BOOL BASSDEF(BASS_ChannelStart)(DWORD handle);
extern fn bool channelStop(uint handle) @extern("BASS_ChannelStop");//BOOL BASSDEF(BASS_ChannelStop)(DWORD handle);
extern fn bool channelPause(uint handle) @extern("BASS_ChannelPause");//BOOL BASSDEF(BASS_ChannelPause)(DWORD handle);
extern fn bool channelUpdate(uint handle,uint length) @extern("BASS_ChannelUpdate");//BOOL BASSDEF(BASS_ChannelUpdate)(DWORD handle, DWORD length);
extern fn bool channelSetAttribute(uint handle,uint arrtib,float value) @extern("BASS_ChannelSetAttribute");//BOOL BASSDEF(BASS_ChannelSetAttribute)(DWORD handle, DWORD attrib, float value);
extern fn bool channelGetAttribute(uint handle,uint attrib,float* value) @extern("BASS_ChannelGetAttribute");//BOOL BASSDEF(BASS_ChannelGetAttribute)(DWORD handle, DWORD attrib, float *value);
extern fn bool channelSlideAttribute(uint handle,uint arrtib,float value,uint time) @extern("BASS_ChannelSlideAttribute");//BOOL BASSDEF(BASS_ChannelSlideAttribute)(DWORD handle, DWORD attrib, float value, DWORD time);
extern fn bool channelIsSliding(uint handle,uint arrtib) @extern("BASS_ChannelIsSliding");//BOOL BASSDEF(BASS_ChannelIsSliding)(DWORD handle, DWORD attrib);
extern fn bool channelSetAttributeEx(uint handle,uint attrib,void* value,uint size) @extern("BASS_ChannelSetAttributeEx");//BOOL BASSDEF(BASS_ChannelSetAttributeEx)(DWORD handle, DWORD attrib, void *value, DWORD size);
extern fn uint channelGetAttributeEx(uint handle,uint attrib,void* value,uint size) @extern("BASS_ChannelGetAttributeEx");//DWORD BASSDEF(BASS_ChannelGetAttributeEx)(DWORD handle, DWORD attrib, void *value, DWORD size);
extern fn bool channelSet3DAttribute(uint handle,int mode,float min,float max,int iangle,int oangle,float outvol) @extern("BASS_ChannelSet3DAttributes");//BOOL BASSDEF(BASS_ChannelSet3DAttributes)(DWORD handle, int mode, float min, float max, int iangle, int oangle, float outvol);
extern fn bool channelGet3DAttributes(uint handle,uint* mode,float* min,float* max,uint* iangle,uint* oangle,float* outvol) @extern("BASS_ChannelGet3DAttributes");//BOOL BASSDEF(BASS_ChannelGet3DAttributes)(DWORD handle, DWORD *mode, float *min, float *max, DWORD *iangle, DWORD *oangle, float *outvol);
extern fn bool channelSet3DPosition(uint handle,Bass_3DVector* pos,Bass_3DVector* orient,Bass_3DVector* vel) @extern("BASS_ChannelSet3DPosition");//BOOL BASSDEF(BASS_ChannelSet3DPosition)(DWORD handle, const BASS_3DVECTOR *pos, const BASS_3DVECTOR *orient, const BASS_3DVECTOR *vel);
extern fn bool channelGet3DPositon(uint handle,Bass_3DVector* pos,Bass_3DVector* orient,Bass_3DVector* vel) @extern("BASS_ChannelGet3DPosition");// BOOL BASSDEF(BASS_ChannelGet3DPosition)(DWORD handle, BASS_3DVECTOR *pos, BASS_3DVECTOR *orient, BASS_3DVECTOR *vel);
extern fn long channelGetLength(uint handle,uint mode) @extern("BASS_ChannelGetLength");//QWORD BASSDEF(BASS_ChannelGetLength)(DWORD handle, DWORD mode);
extern fn bool channelSetPosition(uint handle,ulong pos,uint mode) @extern("BASS_ChannelSetPosition");//BOOL BASSDEF(BASS_ChannelSetPosition)(DWORD handle, QWORD pos, DWORD mode);
extern fn ulong channelGetPosition(uint handle,uint mode) @extern("BASS_ChannelGetPosition");//QWORD BASSDEF(BASS_ChannelGetPosition)(DWORD handle, DWORD mode);
extern fn uint channelGetLevel(uint handle) @extern("BASS_ChannelGetLevel");//DWORD BASSDEF(BASS_ChannelGetLevel)(DWORD handle);
extern fn bool channelGetLevelEx(uint handle,float* levels,float length,uint flags) @extern("BASS_ChannelGetLevelEx");//BOOL BASSDEF(BASS_ChannelGetLevelEx)(DWORD handle, float *levels, float length, DWORD flags);
extern fn uint channelGetData(uint handle,void* buffer,uint length) @extern("BASS_ChannelGetData");//DWORD BASSDEF(BASS_ChannelGetData)(DWORD handle, void *buffer, DWORD length);
extern fn uint channelSetSync(uint handle,uint type,ulong parm,SyncProc* proc,void* user) @extern("BASS_ChannelSetSync");//HSYNC BASSDEF(BASS_ChannelSetSync)(DWORD handle, DWORD type, QWORD param, SYNCPROC *proc, void *user);
extern fn bool channelRemoveSync(uint handle,uint sync) @extern("BASS_ChannelRemoveSync");//BOOL BASSDEF(BASS_ChannelRemoveSync)(DWORD handle, HSYNC sync);
extern fn bool channelSetLink(uint handle,uint chan) @extern("BASS_ChannelSetLink");//BOOL BASSDEF(BASS_ChannelSetLink)(DWORD handle, DWORD chan);
extern fn bool channelRemoveLink(uint handle,uint chan) @extern("BASS_ChannelRemoveLink");//BOOL BASSDEF(BASS_ChannelRemoveLink)(DWORD handle, DWORD chan);
extern fn uint channelSetDSP(uint handle,DspProc* proc,void* user,int priority) @extern("BASS_ChannelSetDSP");//HDSP BASSDEF(BASS_ChannelSetDSP)(DWORD handle, DSPPROC *proc, void *user, int priority);
extern fn bool channelRemoveDSP(uint handle,uint dsp) @extern("BASS_ChannelRemoveDSP");//BOOL BASSDEF(BASS_ChannelRemoveDSP)(DWORD handle, HDSP dsp);
extern fn void channelSetFX(uint handle,uint type,int priority) @extern("BASS_ChannelSetFX");// BASSDEF(BASS_ChannelSetFX)(DWORD handle, DWORD type, int priority);
extern fn bool channelRemoveFx(uint handle,uint fx) @extern("BASS_ChannelRemoveFX");//BOOL BASSDEF(BASS_ChannelRemoveFX)(DWORD handle, HFX fx);

extern fn bool fxSetParameters(uint handle,void* params) @extern("BASS_FXSetParameters");//BOOL BASSDEF(BASS_FXSetParameters)(HFX handle, const void *params);
extern fn bool fxGetParameters(uint handle,void* parames) @extern("BASS_FXGetParameters");//BOOL BASSDEF(BASS_FXGetParameters)(HFX handle, void *params);
extern fn bool fxSetPriority(uint handle,int priority) @extern("BASS_FXSetPriority");//BOOL BASSDEF(BASS_FXSetPriority)(HFX handle, int priority);
extern fn bool fxReset(uint handle) @extern("BASS_FXReset");//BOOL BASSDEF(BASS_FXReset)(DWORD handle);


fn uint pluginLoad(WString file,uint flags)// BASS_PluginLoad(const WCHAR *file, DWORD flags)
{
    return pluginLoad((WString)file,flags|UNICODE);//BASS_PluginLoad((const char*)file, flags | BASS_UNICODE);
}

fn uint musicLoadW(bool mem, WString file,ulong offset, uint length, uint flags, uint freq)
{
	return musicLoad(mem,(void*)file,offset,length,flags|UNICODE,freq);//BASS_MusicLoad(mem, (const void*)file, offset, length, flags | BASS_UNICODE, freq);
}

fn uint sampleLoadW(bool mem,WString file,ulong offset,uint length,uint max,uint flags)// BASS_SampleLoad(BOOL mem, const WCHAR *file, QWORD offset, DWORD length, DWORD max, DWORD flags)
{
	return sampleLoad(mem,(void*)file,offset,length,max,flags|UNICODE);//BASS_SampleLoad(mem, (const void*)file, offset, length, max, flags | BASS_UNICODE);
}

fn uint streamCreateFileW(bool mem,WString file,ulong offset,ulong length,uint flags)//)) BASS_StreamCreateFile(BOOL mem, const WCHAR *file, QWORD offset, QWORD length, DWORD flags)
{
	return streamCreateFile(mem,(void*)file,offset,length,flags|UNICODE);//BASS_StreamCreateFile(mem, (const void*)file, offset, length, flags | BASS_UNICODE);
}

fn uint streamCreateURLW(WString url,uint offset,uint flags,DownloadProc* proc,void* user)//) BASS_StreamCreateURL(const WCHAR *url, DWORD offset, DWORD flags, DOWNLOADPROC *proc, void *user)
{
	return streamCreateURL((ZString)url,offset,flags|UNICODE,proc,user);//BASS_StreamCreateURL((const char*)url, offset, flags | BASS_UNICODE, proc, user);
}

fn bool setConfigPtrW(uint option,WString value)//BASS_SetConfigPtr(DWORD option, const WCHAR *value)
{
	return setConfigPtr(option|UNICODE,(void*)value);//BASS_SetConfigPtr(option | BASS_UNICODE, (const void*)value);
}
