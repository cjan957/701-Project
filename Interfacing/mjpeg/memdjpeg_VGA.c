#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <syslog.h>
#include <sys/stat.h>
#include <math.h>

#include <string.h>
#include <inttypes.h>


#include "jpeglib.h"

#define VGA
#define ENC
#define WRITE_ALL 0

/*
#define NEW_COMPONENT_0_COMPONENT_TYPE new_component
#define NEW_COMPONENT_0_COMPONENT_NAME new_component_0
#define NEW_COMPONENT_0_BASE 0x0a000000
#define NEW_COMPONENT_0_SPAN 4
#define NEW_COMPONENT_0_END 0xa000003
*/


#ifdef VGA
    #include <sys/types.h>
    #include <sys/ipc.h>
    #include <sys/shm.h>
    #include <sys/mman.h>

    #include "hps_0.h"

    #define soc_cv_av
    #include "socal/socal.h"
    #include "socal/hps.h"
    #include "socal/alt_gpio.h"
	
	
	
	//light
    //#define LW_REGS_BASE ( ALT_STM_OFST )
	//#define LW_REGS_SPAN ( 0x4 ) //64 MB with 32 bit adress space this is 256 MB
	#define LW_REGS_MASK ( FILTER_0_LW_SPAN - 1 )

	
	//heavy
	#define HW_REGS_BASE ( ALT_STM_OFST )
    #define HW_REGS_SPAN ( 0x04000000 )
    #define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

    #define AXI_SPAN ( 0x40000000 )
	#define AXI_OFFST ( AXI_SPAN - 1)
	
	//?
    #define FPGA_AXI_BASE   0xC0000000
    #define FPGA_ONCHIP_BASE      (FPGA_AXI_BASE + ONCHIP_SRAM_BASE)
	#define HW_FPGA_AXI_SPAN (0x40000000) 
	
	#define HW_FPGA_AXI_MASK (HW_FPGA_AXI_SPAN - 1)
	
    // modified for 640x480
    //  probably through black magic
    // #define FPGA_ONCHIP_SPAN      0x00040000
    #define FPGA_ONCHIP_SPAN      0x00080000

    #define FPGA_CHAR_BASE (FPGA_AXI_BASE + VGA_SUBSYSTEM_VGA_CHAR_BUFFER_AVALON_CHAR_BUFFER_SLAVE_BASE)
    #define FPGA_CHAR_SPAN VGA_SUBSYSTEM_VGA_CHAR_BUFFER_AVALON_CHAR_BUFFER_SLAVE_SPAN

	
	/* function prototypes */
    void VGA_text (int, int, char *);
    void VGA_text_clear();
    void VGA_box (int, int, int, int, short);

    // pixel buffer
    volatile unsigned int * vga_pixel_ptr = NULL ;
    void *vga_pixel_virtual_base;

    // character buffer
    volatile unsigned int * vga_char_ptr = NULL ;
    void *vga_char_virtual_base;

	void *hw_virtual_base, *lw_virtual_base;
	
	uint64_t* data_hw; 
	uint32_t* encoding_lw;
	
	int fd;
	
    // pixel macro
    #define VGA_PIXEL(x,y,color) do{\
        char  *pixel_ptr ;\
        pixel_ptr = (char *)vga_pixel_ptr + ((y)<<10) + (x) ;\
        *(char *)pixel_ptr = (color);\
    } while(0)
#endif /* VGA */

#ifdef ENC
    #include "ecrypt-sync.h"
    #include "my_trivium-sw_only.c"
#endif /* ENC */

#include <time.h>

struct bmp_out_struct {
    unsigned char *bmp_buffer;
    unsigned long bmp_size;
    int row_stride;
    int width;
    int height;
    int pixel_size;
};

int windowFilter(struct bmp_out_struct *bmp_out);
int decodeMjpeg(unsigned char *mjpeg_buffer, unsigned long mjpeg_size);
int decodeJpeg(struct jpeg_decompress_struct *cinfo, struct bmp_out_struct *bmp_out);
int outputBmp(struct bmp_out_struct *bmp_out);
int outputVGA(struct bmp_out_struct *bmp_out);

#define IMAGE_WIDTH 640
#define IMAGE_HEIGHT 480
#define TARGET_PIXEL_COUNT (IMAGE_WIDTH * IMAGE_HEIGHT)/8

#define IM_DECODE decodeJpeg
#define IM_PROCESS windowFilter
#define CVT2GRYSCALE cvt2Gray
#define IM_OUTPUT outputVGA

//encoding
#define WRITE_CONTROL		0b1
#define WRITE_IMAGE		 	0b010
#define READ_STATUS 		0b011
#define READ_CONTROL		0b100
#define READ_IMAGE_OUT		0b101

//Register positions
#define RESET				0
#define DIST_ACK			1
#define FIFO_READ_DATA_ACK	6
#define ENABLE				7

#define READY_FOR_CHUNK		1
#define FIFO_DATA_READY 	7
        //vga_char_virtual_base = mmap( NULL, FPGA_CHAR_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_CHAR_BASE );


int MapHWAddress()
{
	// === get FPGA addresses ==================
    if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
        printf( "ERROR: could not open \"/dev/mem\"...\n" );
        return( 1 );
    }
	
	
	// HW map
	//hw_virtual_base = mmap( NULL, FILTER_0_HW_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_AXI_BASE);
	
	hw_virtual_base = mmap( NULL, HW_FPGA_AXI_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_AXI_BASE);
	if(hw_virtual_base == MAP_FAILED ) {
        printf( "ERROR: mmap3() failed...\n" );
        close( fd );
        return(1);
    }
	
	data_hw = hw_virtual_base + ((unsigned long)(0x0 + FILTER_0_HW_BASE) & ( unsigned long)( HW_FPGA_AXI_MASK ) );

	return 0;	
}

int MapLWAddress()
{
	// === get FPGA addresses ==================
    if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
        printf( "ERROR: could not open \"/dev/mem\"...\n" );
        return( 1 );
    }

	// Light Weight
	lw_virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE);
	if(lw_virtual_base == MAP_FAILED ) {
        printf( "ERROR: mmap3() failed...\n" );
        close( fd );
        return(1);
    }
	
	
	encoding_lw = lw_virtual_base + (( unsigned long  )( ALT_LWFPGASLVS_OFST + FILTER_0_LW_BASE ) & ( unsigned long)( HW_REGS_MASK ));
	
	return 0;
	
}

int UnMapHWAddress()
{
	
	if( munmap( hw_virtual_base, HW_FPGA_AXI_SPAN ) != 0 ) {
        printf( "ERROR: HW munmap() failed...\n" );
        close( fd );
        return( 1 );
    }

	close(fd);
	return 0;
}

int UnMapLWAddress()
{
 	
	if( munmap( lw_virtual_base, HW_REGS_SPAN ) != 0 ) {
        printf( "ERROR: LW munmap() failed...\n" );
        close( fd );
        return( 1 );
    }
	close(fd);
	return 0;
	
}

uint64_t ReadFromControlRegister()
{
	MapLWAddress();
	*(uint32_t *)encoding_lw = READ_CONTROL;
	UnMapLWAddress();
	
	usleep(1);
	
	MapHWAddress();
	uint64_t readData = *(uint64_t*)data_hw;
	UnMapHWAddress();
	return readData;
}

uint64_t ReadFromStatusRegister()
{
	MapLWAddress();
	*(uint32_t *)encoding_lw = READ_STATUS;
	UnMapLWAddress();
	
	usleep(1);
	
	MapHWAddress();
	uint64_t readData = *(uint64_t*)data_hw;
	UnMapHWAddress();
	return readData;
}

uint64_t ReadFromImageOutRegister()
{
	MapLWAddress();
	*(uint32_t *)encoding_lw = READ_IMAGE_OUT;
	UnMapLWAddress();
	
	usleep(1);
	
	MapHWAddress();
	uint64_t readData = *(uint64_t*)data_hw;
	UnMapHWAddress();
	return readData;
}

void WriteToControlRegister(u64 data)
{
	MapHWAddress();
	*(uint64_t *)data_hw 	= data;
	UnMapHWAddress();
	
	usleep(1);
	
	MapLWAddress();
	*(uint32_t *)encoding_lw = WRITE_CONTROL;
	UnMapLWAddress();
}

void WriteToImageInRegister(u64 data)
{
	MapHWAddress();
	*(uint64_t *)data_hw = data;
	UnMapHWAddress();
	
	usleep(1);
	
	MapLWAddress();
	*(uint32_t *)encoding_lw = WRITE_IMAGE;
	UnMapLWAddress();
}

void ResetHardware()
{
	u64 controlReg = ReadFromControlRegister();
	
	printf("Control before reset %#" PRIx64 "\n", controlReg);
	printf("print normal %d \n", controlReg);

	controlReg |= (1UL << RESET);
	WriteToControlRegister(controlReg);
	
	printf("Control after reset %#" PRIx64 "\n", controlReg);

	
	controlReg &= ~(1UL << RESET);
	
	printf("Control before writing  %#" PRIx64 "\n", controlReg);
	WriteToControlRegister(controlReg);
}


int windowFilter(struct bmp_out_struct *bmp_out) {
    // Take a few local copies to make the code a bit easier to read
    unsigned char *bmp_buffer = bmp_out->bmp_buffer;
    // Filter
    unsigned char *bmp_processed = (unsigned char*) malloc(bmp_out->bmp_size);
	
	uint64_t statusRegister;
	uint64_t controlRegister;
	
	u8 buffer_p1 = NULL;
	u8 buffer_p2 = NULL;
	u8 buffer_p3 = NULL;
	u8 buffer_p4 = NULL;
	u8 buffer_p5 = NULL;
	u8 buffer_p6 = NULL;
	u8 buffer_p7 = NULL;
	u8 buffer_p8 = NULL;
	
	u64 combined_image_chunk = 0;
	u64 register_buffer = 0;
	u64 imageChunk = 0;
	
	u8 eightBitChunk = 0; 
	
	int outputPixelChunkCount = 0;
	u8 wholeImageDistributed = 0;
	
	int row_out = 0;
	int col_out = 0;
	

	while(outputPixelChunkCount != TARGET_PIXEL_COUNT)
	{
		if(wholeImageDistributed == 0)
		{
			for (int row = 0; row < (bmp_out->height); ++row)
			{
				for(int col = 0; col < (bmp_out->width); col += 8)  //verify this loop condition
				{
					#define val(row, col) bmp_buffer[(row)*bmp_out->row_stride + (col)*bmp_out->pixel_size] 
					buffer_p1 = val(row, col);
					buffer_p2 = val(row, col + 1);
					buffer_p3 = val(row, col + 2);
					buffer_p4 = val(row, col + 3);
					buffer_p5 = val(row, col + 4);
					buffer_p6 = val(row, col + 5);
					buffer_p7 = val(row, col + 6);
					buffer_p8 = val(row, col + 7);
					#undef val
					
					combined_image_chunk = (u64)buffer_p1 << 56 | (u64)buffer_p2 << 48 | (u64)buffer_p3 << 40 | (u64)buffer_p4 << 32 | (u64)buffer_p5 << 24 | (u64)buffer_p6 << 16 | (u64)buffer_p7 << 8 | (u64)buffer_p8;
					
					printf("VALUE imageChunk is %#" PRIx64 "\n", combined_image_chunk);
				
					//pass in a chunk
					WriteToImageInRegister(combined_image_chunk);
					
					//send enable signal
					register_buffer = ReadFromControlRegister();
					
					printf("before masking is %#" PRIx64 "\n", register_buffer);
					register_buffer |= (1 << ENABLE);
					printf("after masking is %#" PRIx64 "\n", register_buffer);

					WriteToControlRegister(register_buffer);

					//Grab status register content
					statusRegister = ReadFromStatusRegister();
					
					//if there's data from the fifo to grab
					if(((statusRegister >> FIFO_DATA_READY) & 1) == 1)
					{
						//grab a chunk
						imageChunk = ReadFromImageOutRegister();
						printf("VALUE imageChunk is %#" PRIx64 "\n", imageChunk);

						for(int pixel = 0; pixel < 8; pixel++)
						{
							if (pixel == 0)
							{
								eightBitChunk = imageChunk & 0xFF;
							} 
							else 
							{
								eightBitChunk = (imageChunk >> (pixel * 8));
							}
							bmp_processed[(row_out*bmp_out->row_stride) + (col_out)*bmp_out->pixel_size + 0] = eightBitChunk;
							bmp_processed[(row_out*bmp_out->row_stride) + (col_out)*bmp_out->pixel_size + 1] = eightBitChunk;
							bmp_processed[(row_out*bmp_out->row_stride) + (col_out)*bmp_out->pixel_size + 2] = eightBitChunk;
							
							
							col_out++;
							
							if (col_out == IMAGE_WIDTH) {
								col_out = 0;
								row_out++;
							}
								
							if (row_out == IMAGE_HEIGHT) break;	
							
							
						}	
						outputPixelChunkCount++;
					}
					
					statusRegister = ReadFromStatusRegister();
					
					//check for 'ready for a (new) chunk' signal
				 	while(((statusRegister >> READY_FOR_CHUNK) & 1) == 0)
					{
						statusRegister = ReadFromStatusRegister();
						printf("StatusRegister content is %#" PRIx64 "\n", statusRegister);
					}	 
					
					controlRegister = ReadFromControlRegister();
					register_buffer = (controlRegister) & ~(1 << ENABLE); //set enable to low
					register_buffer = (register_buffer) | (1 << DIST_ACK);
					WriteToControlRegister(register_buffer); //write back
						
					//reading from control reg, then write to it 
						
					controlRegister = ReadFromControlRegister();
					register_buffer = (controlRegister) & ~(1 << DIST_ACK);
					WriteToControlRegister(register_buffer);
				}
			}
			wholeImageDistributed = 1;
		}
		else
		{
			printf("FINISHED INPUTTING IMAGE\n");
			
			if(((statusRegister >> FIFO_DATA_READY) & 1) == 1)
			{
				//grab a chunk
				imageChunk = ReadFromImageOutRegister();					
				for(int pixel = 0; pixel < 8; pixel++)
				{
					if (pixel == 0)
					{
						eightBitChunk = imageChunk & 0xFF;
					} 
					else 
					{
						eightBitChunk = (imageChunk >> (pixel * 8));
					}
					
					bmp_processed[(row_out*bmp_out->row_stride) + (col_out)*bmp_out->pixel_size + 0] = eightBitChunk;
					bmp_processed[(row_out*bmp_out->row_stride) + (col_out)*bmp_out->pixel_size + 1] = eightBitChunk;
					bmp_processed[(row_out*bmp_out->row_stride) + (col_out)*bmp_out->pixel_size + 2] = eightBitChunk;	
					
					col_out++;
							
					if (col_out == IMAGE_WIDTH) {
							col_out = 0;
							row_out++;
					}
					
					if (row_out == IMAGE_HEIGHT) break;
					
					
				}
				outputPixelChunkCount++;
			}
		}
	}
	
	printf("FRAME DONE!\n");
	ResetHardware();

    // Replace input with output
    memcpy(bmp_buffer, bmp_processed, bmp_out->bmp_size);
    return 1;
}

int cvt2Gray(struct bmp_out_struct *bmp_out) {
    // Take a few local copies to make the code a bit easier to read
    unsigned char *bmp_buffer = bmp_out->bmp_buffer;
    // Filter
    unsigned char *bmp_processed = (unsigned char*) malloc(bmp_out->bmp_size);
    // Iterate over full image
    //unsigned char middle = 0;
	
	unsigned char grayscale = 0;
	int chan = 0;
	
	double RED = 0;
	double GREEN = 0;
	double  BLUE = 0;
	
	#define RED_CONST 0.2989
	#define GREEN_CONST 0.5870
	#define BLUE_CONST 0.1140
	
	for (int row=0; row<bmp_out->height; ++row) {
        for (int col=0; col<bmp_out->width; ++col) {
            // Work on each channel independently
			for (chan=0; chan<bmp_out->pixel_size; ++chan) {
               
                #define val(row, col) bmp_buffer[(row)*bmp_out->row_stride + (col)*bmp_out->pixel_size + chan]
                    
				switch (chan) {
					case 0: // Red
						RED = (double) val(row,col);
					break;

					case 1: // Green
						GREEN = (double) val(row,col);
					break;
						
					case 2: // Blue
						BLUE  = (double) val(row,col);
					break;
						
					default:
						break;						
				}

				#undef val
						
                
            }
			
			// Calculate gray scale
			grayscale = (RED * RED_CONST) + (GREEN * GREEN_CONST) + (BLUE * BLUE_CONST);
			
			// Set output
			bmp_processed[(row*bmp_out->row_stride) + col*bmp_out->pixel_size + 0] = grayscale;
			bmp_processed[(row*bmp_out->row_stride) + col*bmp_out->pixel_size + 1] = grayscale;
			bmp_processed[(row*bmp_out->row_stride) + col*bmp_out->pixel_size + 2] = grayscale;
			
			RED = 0;
			GREEN = 0;
			BLUE = 0;
			
			grayscale = 0;
			chan = 0;			
        }
    }

    // Replace input with output
    memcpy(bmp_buffer, bmp_processed, bmp_out->bmp_size);
    return 1;
}

int main (int argc, char *argv[]) {
		
	int rc, i;
    

	char *syslog_prefix = (char*) malloc(1024);
	sprintf(syslog_prefix, "%s", argv[0]);
	openlog(syslog_prefix, LOG_PERROR | LOG_PID, LOG_USER);

    #ifdef ENC
        if (argc != 3) {
            fprintf(stderr, "USAGE: %s encrypted_file unencrypted_file\n", argv[0]);
            exit(EXIT_FAILURE);
        }
        char *encfile = argv[1];
        char *infile = argv[2];
    #else
        if (argc != 2) {
            fprintf(stderr, "USAGE: %s input_file\n", argv[0]);
            exit(EXIT_FAILURE);
        }
        char *infile = argv[1];
    #endif

    #ifdef VGA
        // === get FPGA addresses ==================
        // Open /dev/mem
        if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) 	{
            printf( "ERROR: could not open \"/dev/mem\"...\n" );
            return( 1 );
        }

        // === get VGA char addr =====================
        // get virtual addr that maps to physical
        vga_char_virtual_base = mmap( NULL, FPGA_CHAR_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_CHAR_BASE );
        if( vga_char_virtual_base == MAP_FAILED ) {
            printf( "ERROR: mmap2() failed...\n" );
            close( fd );
            return(1);
        }

        // Get the address that maps to the FPGA LED control
        vga_char_ptr =(unsigned int *)(vga_char_virtual_base);

        // === get VGA pixel addr ====================
        // get virtual addr that maps to physical
        vga_pixel_virtual_base = mmap( NULL, FPGA_ONCHIP_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, FPGA_ONCHIP_BASE);
        if( vga_pixel_virtual_base == MAP_FAILED ) {
            printf( "ERROR: mmap3() failed...\n" );
            close( fd );
            return(1);
        }
		
        // Get the address that maps to the FPGA pixel buffer
        vga_pixel_ptr =(unsigned int *)(vga_pixel_virtual_base);

        // ===========================================
        // clear the screen
        VGA_box (0, 0, 639, 479, 0x00);
        // clear the text
        VGA_text_clear();
    #endif
	
	
	//ResetHardware();	

	
	//WriteToControlRegister(0b 11111111 00000000 11111111 00000000 11111111 00001000 11111111 00000000);
 	/* WriteToControlRegister(0x32311);
	u64 read_c = ReadFromControlRegister();
	printf("VALUE (HEAVY) is %#" PRIx64 "\n", read_c);
	
	ResetHardware();	

	WriteToControlRegister(0x3231a);
	read_c = ReadFromControlRegister();
	printf("CONTROL (HEAVY) is %#" PRIx64 "\n", read_c); 
	 */
	
	ResetHardware();
	
	
	
	

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	

//   SSS    EEEEEEE  TTTTTTT  U     U  PPPP
// SS   SS  E           T     U     U  P   PP
// S        E           T     U     U  P    PP
// SS       E           T     U     U  P   PP
//   SSS    EEEE        T     U     U  PPPP
//      SS  E           T     U     U  P
//       S  E           T     U     U  P
// SS   SS  E           T      U   U   P
//   SSS    EEEEEEE     T       UUU    P

	// Variables for the source jpg
	struct stat file_info;
	unsigned long mjpg_size;
	unsigned char *mjpg_buffer;

    #ifdef ENC
        // Unencrypt file
        trivium_decrypt_file(encfile, infile);
    #endif

	// Load the jpeg data from a file into a memory buffer for
	// the purpose of this demonstration.
	// Normally, if it's a file, you'd use jpeg_stdio_src, but just
	// imagine that this was instead being downloaded from the Internet
	// or otherwise not coming from disk
	rc = stat(infile, &file_info);
	if (rc) {
		syslog(LOG_ERR, "FAILED to stat source jpg");
		exit(EXIT_FAILURE);
	}
	mjpg_size = file_info.st_size;
	mjpg_buffer = (unsigned char*) malloc(mjpg_size + 100);

	fd = open(infile, O_RDONLY);
	i = 0;
	while (i < mjpg_size) {
		rc = read(fd, mjpg_buffer + i, mjpg_size - i);
		syslog(LOG_INFO, "Input: Read %d/%lu bytes", rc, mjpg_size-i);
		i += rc;
	}
	close(fd);

    // Decode MJPEG
    rc = decodeMjpeg(mjpg_buffer, mjpg_size);

	// And free the input buffer
	free(mjpg_buffer);

    return rc;
}

int decodeMjpeg(unsigned char *mjpeg_buffer, unsigned long mjpeg_size) {
    //   SSS    TTTTTTT     A     RRRR     TTTTTTT
    // SS   SS     T       A A    R   RR      T
    // S           T      A   A   R    RR     T
    // SS          T     A     A  R   RR      T
    //   SSS       T     AAAAAAA  RRRR        T
    //      SS     T     A     A  R RR        T
    //       S     T     A     A  R   R       T
    // SS   SS     T     A     A  R    R      T
    //   SSS       T     A     A  R     R     T


	syslog(LOG_INFO, "Proc: Create Decompress struct");
	// Allocate a new decompress struct, with the default error handler.
	// The default error handler will exit() on pretty much any issue,
	// so it's likely you'll want to replace it or supplement it with
	// your own.
	struct jpeg_decompress_struct cinfo;
	struct jpeg_error_mgr jerr;
	cinfo.err = jpeg_std_error(&jerr);
	jpeg_create_decompress(&cinfo);


	syslog(LOG_INFO, "Proc: Set memory buffer as source");
	// Configure this decompressor to read its data from a memory
	// buffer starting at unsigned char *jpg_buffer, which is jpg_size
	// long, and which must contain a complete jpg already.
	//
	// If you need something fancier than this, you must write your
	// own data source manager, which shouldn't be too hard if you know
	// what it is you need it to do. See jpeg-8d/jdatasrc.c for the
	// implementation of the standard jpeg_mem_src and jpeg_stdio_src
	// managers as examples to work from.
	jpeg_mem_src(&cinfo, mjpeg_buffer, mjpeg_size);


    /* Injecting MJPEG support (from raw video format)
     *
     * The jpeg_mem_src will continue to read from the same buffer just fine
     *  on its own. All we need to do is keep going and catching it before it
     *  can fail (i.e. we need to detect the final frame).
     *
     * * * * * * * * Begin * * * * * * * */

    clock_t begin = clock();
    unsigned int jpg_count = 0;
    while (*(cinfo.src->next_input_byte)) {
        // Prepare
        struct bmp_out_struct bmp_out;

        // Decode
        IM_DECODE(&cinfo, &bmp_out);
		
		        
		#ifdef CVT2GRYSCALE
            CVT2GRYSCALE(&bmp_out);
        #endif

        // Process
        #ifdef IM_PROCESS
           IM_PROCESS(&bmp_out);
        #endif

        // Output
        #ifdef IM_OUTPUT
            IM_OUTPUT(&bmp_out);
        #endif

        // Clean up
        free((void*)bmp_out.bmp_buffer);
        jpg_count++;
    }
    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    syslog(LOG_INFO, "Successfully loaded %u JPEGs in %fs", jpg_count, time_spent);

	// Once you're really really done, destroy the object to free everything
	jpeg_destroy_decompress(&cinfo);

// DDDD       OOO    N     N  EEEEEEE
// D  DDD    O   O   NN    N  E
// D    DD  O     O  N N   N  E
// D     D  O     O  N N   N  E
// D     D  O     O  N  N  N  EEEE
// D     D  O     O  N   N N  E
// D    DD  O     O  N   N N  E
// D  DDD    O   O   N    NN  E
// DDDD       OOO    N     N  EEEEEEE

	syslog(LOG_INFO, "End of decompression");
	return EXIT_SUCCESS;
}


/** Function to decode individual frame
 * Take pointer to encoded JPEG (in memory), return a pointer to the decoded BMP
 *  Don't forget to free memory
 **/
int decodeJpeg(struct jpeg_decompress_struct *cinfo, struct bmp_out_struct *bmp_out) {
    //syslog(LOG_INFO, "Proc: Read the JPEG header");
    // Have the decompressor scan the jpeg header. This won't populate
    // the cinfo struct output fields, but will indicate if the
    // jpeg is valid.
    int rc = jpeg_read_header(cinfo, TRUE);

    if (rc != 1) {
        syslog(LOG_ERR, "File does not seem to be a normal JPEG");
        exit(EXIT_FAILURE);
    }

    //syslog(LOG_INFO, "Proc: Initiate JPEG decompression");
    // By calling jpeg_start_decompress, you populate cinfo
    // and can then allocate your output bitmap buffers for
    // each scanline.
    jpeg_start_decompress(cinfo);

    bmp_out->width = cinfo->output_width;
    bmp_out->height = cinfo->output_height;
    bmp_out->pixel_size = cinfo->output_components;

    //syslog(LOG_INFO, "Proc: Image is %d by %d with %d components",
    //        width, height, pixel_size);

    bmp_out->bmp_size = bmp_out->width * bmp_out->height * bmp_out->pixel_size;
    bmp_out->bmp_buffer = (unsigned char*) malloc(bmp_out->bmp_size);

    // The row_stride is the total number of bytes it takes to store an
    // entire scanline (row).
    bmp_out->row_stride = bmp_out->width * bmp_out->pixel_size;

    //syslog(LOG_INFO, "Proc: Start reading scanlines");
    //
    // Now that you have the decompressor entirely configured, it's time
    // to read out all of the scanlines of the jpeg.
    //
    // By default, scanlines will come out in RGBRGBRGB...  order,
    // but this can be changed by setting cinfo->out_color_space
    //
    // jpeg_read_scanlines takes an array of buffers, one for each scanline.
    // Even if you give it a complete set of buffers for the whole image,
    // it will only ever decompress a few lines at a time. For best
    // performance, you should pass it an array with cinfo->rec_outbuf_height
    // scanline buffers. rec_outbuf_height is typically 1, 2, or 4, and
    // at the default high quality decompression setting is always 1.
    while (cinfo->output_scanline < cinfo->output_height) {
        unsigned char *buffer_array[1];
        buffer_array[0] = bmp_out->bmp_buffer + \
                           (cinfo->output_scanline) * bmp_out->row_stride;

        jpeg_read_scanlines(cinfo, buffer_array, 1);

    }
    //syslog(LOG_INFO, "Proc: Done reading scanlines");

    // Once done reading *all* scanlines, release all internal buffers,
    // etc by calling jpeg_finish_decompress. This lets you go back and
    // reuse the same cinfo object with the same settings, if you
    // want to decompress several jpegs in a row.
    //
    // If you didn't read all the scanlines, but want to stop early,
    // you instead need to call jpeg_abort_decompress(cinfo)
    jpeg_finish_decompress(cinfo);

    // At this point, optionally go back and either load a new jpg into
    // the jpg_buffer, or define a new jpeg_mem_src, and then start
    // another decompress operation.

    return 1;
}

int outputBmp(struct bmp_out_struct *bmp_out) {
    static unsigned int jpg_count = 0;
    int ret = 0;
    // Only output every 240 frames
    if (WRITE_ALL || !(jpg_count % 240)) {
        // Write the decompressed bitmap out to a ppm file, just to make sure
        // it worked.
        char outfile[20];
        sprintf(outfile, "output%d.ppm", jpg_count);
        int fd = open(outfile, O_CREAT | O_WRONLY, 0666);
        char buf[1024];

        int rc = sprintf(buf, "P6 %d %d 255\n", bmp_out->width, bmp_out->height);
        write(fd, buf, rc); // Write the PPM image header before data
        write(fd, bmp_out->bmp_buffer, bmp_out->bmp_size); // Write out all RGB pixel data

        close(fd);

        syslog(LOG_INFO, "Output frame %u successful", jpg_count);
        ret = 1;
    }
    ++jpg_count;
    return ret;
}

int outputVGA(struct bmp_out_struct *bmp_out) {
    #ifdef VGA
        for (int i=1; i<bmp_out->width; ++i) {
            if (i >= 640) break;
            for (int j=1; j<bmp_out->height; ++j) {
                //printf("\t, %d\n", j);
                if (j >= 480) break;
                char pixel_colour;
                #define val(row, col, chan) bmp_out->bmp_buffer[(row)*bmp_out->row_stride + (col)*bmp_out->pixel_size + chan]
                pixel_colour = (val(j, i, 0) & 0xe0) >> 0 | (val(j, i, 1) & 0xe0) >> 3 | (val(j, i, 2) & 0xc0) >> 6;
                VGA_PIXEL(i, j, pixel_colour);
            }
        }
        return 1;
    #else
        return 0;
    #endif
}

#ifdef VGA
    /****************************************************************************************
     * Subroutine to send a string of text to the VGA monitor
    ****************************************************************************************/
    void VGA_text(int x, int y, char * text_ptr)
    {
        volatile char * character_buffer = (char *) vga_char_ptr ;	// VGA character buffer
        int offset;
        /* assume that the text string fits on one line */
        offset = (y << 7) + x;
        while ( *(text_ptr) )
        {
            // write to the character buffer
            *(character_buffer + offset) = *(text_ptr);
            ++text_ptr;
            ++offset;
        }
    }

    /****************************************************************************************
     * Subroutine to clear text to the VGA monitor
    ****************************************************************************************/
    void VGA_text_clear()
    {
        volatile char * character_buffer = (char *) vga_char_ptr ;	// VGA character buffer
        int offset, x, y;
        for (x=0; x<70; x++){
            for (y=0; y<40; y++){
        /* assume that the text string fits on one line */
                offset = (y << 7) + x;
                // write to the character buffer
                *(character_buffer + offset) = ' ';
            }
        }
    }

    /****************************************************************************************
     * Draw a filled rectangle on the VGA monitor
    ****************************************************************************************/
    #define SWAP(X,Y) do{int temp=X; X=Y; Y=temp;}while(0)

    void VGA_box(int x1, int y1, int x2, int y2, short pixel_color)
    {
        char  *pixel_ptr ;
        int row, col;

        /* check and fix box coordinates to be valid */
        if (x1>639) x1 = 639;
        if (y1>479) y1 = 479;
        if (x2>639) x2 = 639;
        if (y2>479) y2 = 479;
        if (x1<0) x1 = 0;
        if (y1<0) y1 = 0;
        if (x2<0) x2 = 0;
        if (y2<0) y2 = 0;
        if (x1>x2) SWAP(x1,x2);
        if (y1>y2) SWAP(y1,y2);
        for (row = y1; row <= y2; row++)
            for (col = x1; col <= x2; ++col)
            {
                //640x480
                pixel_ptr = (char *)vga_pixel_ptr + (row<<10)    + col ;
                // set pixel color
                *(char *)pixel_ptr = pixel_color;
            }
    }
#endif


