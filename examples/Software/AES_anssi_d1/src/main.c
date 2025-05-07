/* Conditionnaly include static tests */
#ifdef STATIC_TESTS_PRESENT
#include "aes_tests.h"
const char *static_tests = (const char*)&aes_static_tests;
unsigned int static_tests_size = sizeof(aes_static_tests);
#else
const char *static_tests = 0;
unsigned int static_tests_size = 0;
#endif

#if defined(USE_QEMU_PLATFORM) || defined(USE_KEIL_PLATFORM)
/* QEMU and Keil platform */

#include "aes.h"
#include "test.h"
#include "platform.h"
#include "string.h"
#include <stdint.h>
#include <stdio.h>

uint8_t input_s1[16] __attribute__((section(".data")));

__attribute__((noreturn, noinline)) void report_done()
{
    report_done();
}

int main(int argc, char *argv[]){

	if(static_tests != NULL){
		perform_aes_tests(&static_tests, NULL);
	}
	perform_aes_tests(NULL, NULL);

	return 0;
}

#elif defined(USE_STM32_DISCO_PLATFORM)
/* STM32 Discovery platform */

// #include "debug.h"
// #include "leds.h"
// #include "helpers.h"
// #include "init.h"
// #include "stm32f4xx_usart.h"
#include "aes.h"
// #include "test.h"
#include <stdint.h>

uint32_t randomness __attribute__((section(".randomness")));
uint8_t input_s1[16] __attribute__((section(".data")));

__attribute__((noreturn, noinline)) void report_done()
{
    report_done();
}

// static volatile usart_config_t console_config = {0};
// static volatile int logging = 1;

// static void console_data_received(void)
// {
// 	char c = usart_getc(console_config.usart);
// 	if (c != ' ' && c != 'p') {
// 		dbg_flush();
// 		return;
// 	}

// 	logging = !logging;
// 	if (logging){
// 		dbg_log("Logging enabled\n");
// 	}
// 	else{
// 		dbg_log("Logging disabled\n");
// 	}
// 	dbg_flush();
// }

// static volatile usart_config_t protocol_config = {0};

// extern void _comm_byte_received(void);

// cb_usart_getc_t protocol_getc = NULL;
// cb_usart_putc_t protocol_putc = NULL;
// void protocol_init(usart_config_t *config){

//     /* Configure the USART in UART mode */
//     if (config != NULL){
//         config->set_mask = USART_SET_ALL;
//         config->usart = PROD_PROTOCOL_USART;
//         config->baudrate = 115200;
//         config->word_length = USART_CR1_M_8;
//         config->stop_bits = USART_CR2_STOP_1BIT;
//         config->parity = USART_CR1_PCE_DIS;
//         config->hw_flow_control = USART_CR3_CTSE_CTS_DIS | USART_CR3_RTSE_RTS_DIS;
//         /* We disable the TX interrupt since we will handle it with polling */
//         config->options_cr1 = USART_CR1_TE_EN | USART_CR1_RE_EN | USART_CR1_UE_EN | USART_CR1_RXNEIE_EN | USART_CR1_TCIE_DIS;
//         if(config->callback_irq_handler == NULL){
//             config->callback_irq_handler = _comm_byte_received;
//         }
//         if(config->callback_usart_getc_ptr == NULL){
//             config->callback_usart_getc_ptr = &protocol_getc;
//         }
//         if(config->callback_usart_putc_ptr == NULL){
//             config->callback_usart_putc_ptr = &protocol_putc;
//         }
//     }
//     else{
//         return;
//     }
//     /* Initialize the USART related to the console */
//     usart_init(config);
//     dbg_log("[USART%d initialized for AES tests protocol input/output, baudrate=%d]\n", config->usart, config->baudrate);
//     dbg_flush();
// }

// unsigned int led_num = 0;
// static void toggle_leds(void){
// 	if(led_num % 4 == 0){
// 		leds_on(LED3);
// 		leds_off(LED4);
// 		leds_off(LED5);
// 		leds_off(LED6);
// 	}
// 	if(led_num % 4 == 1){
// 		leds_off(LED3);
// 		leds_on(LED4);
// 		leds_off(LED5);
// 		leds_off(LED6);
// 	}
// 	if(led_num % 4 == 2){
// 		leds_off(LED3);
// 		leds_off(LED4);
// 		leds_on(LED5);
// 		leds_off(LED6);
// 	}
// 	if(led_num % 4 == 3){
// 		leds_off(LED3);
// 		leds_off(LED4);
// 		leds_off(LED5);
// 		leds_on(LED6);
// 	}
// 	led_num++;
// }

#pragma GCC push_options
#pragma GCC optimize ("O0")
void get_external_randomness(UCHAR* random_aes, UCHAR* random_key){
	for(int i = 0; i < 19; ++i){
		random_aes[i] = (UCHAR)randomness;
		random_key[i] = (UCHAR)randomness;
	}
}

#pragma GCC pop_options

int main(int argc, char * args[])
{
	
	// char * base_address = 0;

	// disable_irq();

	// if (argc == 1){
	// 	base_address = (char * )args[0];
	// 	system_init((uint32_t)base_address-VTORS_SIZE);
	// }
	// else{
 	// 	// panic("Unable to find base address\n");
	// 	return -1;
	// }
	// leds_init();

	// /* Configure the USART debug console */	
	// console_config.callback_irq_handler = console_data_received;
	// debug_console_init((usart_config_t*)&console_config);
	// enable_irq();

	// dbg_log("======== AES TEST =========\n");
    //     dbg_log("\tBuilt date\t: %s at %s\n", __DATE__, __TIME__);
    //     dbg_log("\tBoard\t\t: STM32F407 Discovery\n");
    //     dbg_log("==============================\n");
	// dbg_flush();

	// /* Configure the USAERT protocol console for AES tests */	
	// protocol_init((usart_config_t*)&protocol_config);

	// if(static_tests != NULL){
	// 	perform_aes_tests(&static_tests, toggle_leds);
	// }
	// perform_aes_tests(NULL, toggle_leds);
    UINT Mode;
    STRUCT_AES aes_struct;
    UCHAR in[16];  
    UCHAR out[16];
	for(int i = 0; i < 16; ++i){
		in[i] = (UCHAR)input_s1[i];
	}
    UCHAR key[16] = {0x2b,0x7e, 0x15, 0x16 ,0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c};
    Mode = MODE_KEYINIT|MODE_AESINIT_ENC|MODE_ENC|MODE_RANDOM_KEY_EXT|MODE_RANDOM_AES_EXT;
    UCHAR random_key[19];
    UCHAR random_aes[19];

	get_external_randomness(random_aes, random_key);
    


    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/
   aes(Mode, &aes_struct, key, in, out, random_key, random_aes);

	for(int i = 0; i < 16; ++i){
		input_s1[i] = out[i];
	}

	report_done();

	return 0;
}
#else

#error "Uknown platform! You must define either USE_QEMU_PLATFORM, USE_KEIL_PLATFORM or USE_STM32_DISCO_PLATFORM"

#endif
