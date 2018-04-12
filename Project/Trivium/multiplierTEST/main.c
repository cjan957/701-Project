#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

#define soc_cv_av
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"

#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

int main() {
	// Open device memory as a file
	// 	This lets us access the FPGA peripherals
	int fd;
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	// Map hardware registers into memory
	void *virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if(virtual_base == MAP_FAILED) {
		printf("ERROR: mmap() failed...\n");
		close(fd);
		return(1);
	}


#ifdef MULTIPLIER_INA_COMPONENT_NAME
	void *h2p_lw_mult_a_addr = virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MULTIPLIER_INA_BASE) & (unsigned long)(HW_REGS_MASK));
	void *h2p_lw_mult_b_addr = virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MULTIPLIER_INB_BASE) & (unsigned long)(HW_REGS_MASK));

	void *h2p_lw_mult_out_addr = virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MULTIPLIER_OUT_BASE) & (unsigned long)(HW_REGS_MASK));

	*(uint32_t *)h2p_lw_mult_a_addr = 0b00001111;
	*(uint32_t *)h2p_lw_mult_b_addr = 0b00010101;

	int result = *(uint32_t *)h2p_lw_mult_out_addr;
	printf("Output: %d\n", result);


#else
	printf("NOPE\n");
#endif
	// Note that if you did not call your peripheral pio_led (case insensitive)
	//	then you may need to change the macros below
	//	#ifdef PIO_LED_COMPONENT_NAME
	//		printf("Found an LED component!\n");
	//
	//		// Point to the LED control register
	//		void *h2p_lw_led_addr = virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PIO_LED_BASE) & (unsigned long)(HW_REGS_MASK));
	//
	//		// Set the led mask to all bits
	//		//	e.g. if 4 bit width the mask is 0b10000 - 1 = 0b1111
	//		const int led_mask = (1 << (PIO_LED_DATA_WIDTH)) - 1; // e.g.
	//
	//		// You will need to modify the code below in order to perform the test demonstration
	//
	//		// Set the output
	//		*(uint32_t *)h2p_lw_led_addr = 0xffff & led_mask;
	//
	//		// Delay by 1 second
	//		usleep (1000 * 1000);
	//
	//		// Finish
	//	#else
	//		printf("These aren't the LEDs you're looking for\n");
	//	#endif

	// clean up our memory mapping and exit
	if(munmap(virtual_base, HW_REGS_SPAN) != 0) {
		printf("ERROR: munmap() failed...\n");
		close(fd);
		return(1);
	}

	close(fd);

	return(0);
}
