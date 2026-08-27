/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <unistd.h>
#include "system.h"
#include "io.h"

int main()
{
  int status;
  int sample;

  printf("Starting Oscilloscope Capture...\n");

  while(1)
  {

  /* Set trigger level */
  IOWR(OSCILLOSCOPE_AVMM_0_BASE, 1, 20);

  /* Start a new capture */
  IOWR(OSCILLOSCOPE_AVMM_0_BASE, 0, 1);
  IOWR(OSCILLOSCOPE_AVMM_0_BASE, 0, 0);

  /* Wait for capture_done */
  status = IORD(OSCILLOSCOPE_AVMM_0_BASE, 2);

  while ((status & 0x2) == 0)
  {
      status = IORD(OSCILLOSCOPE_AVMM_0_BASE, 2);
  }

  printf("Capture complete!\n");

  /* Read the 32 samples */
  for (int i=0; i<32; i++)
  {
	  IOWR(OSCILLOSCOPE_AVMM_0_BASE, 3, i);
	  usleep(1);
	  sample= IORD(OSCILLOSCOPE_AVMM_0_BASE, 4);
	  printf("Sample %d = %d\n", i, sample);
  }

  /* Tell Python one complete frame has finished */
  printf("END\n");

  /* Small pause before next capture */
  usleep(100000);

  }

  return 0;

}
