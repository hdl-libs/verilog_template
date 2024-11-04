// ---------------------------------------------------------------------------------------
// Copyright (c) 2024 john_tito All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// ---------------------------------------------------------------------------------------

/**
 * @file verilog_template.h
 * @brief
 * @author
 */

#ifndef _VERILOG_TEMPLATE_H_
#define _VERILOG_TEMPLATE_H_

#ifdef __cplusplus
extern "C" {
#endif

/******************************************************************************/
/************************ Include Files ***************************************/
/******************************************************************************/

#include <stdbool.h>
#include <stdint.h>

/******************************************************************************/
/************************ Marco Definitions ***********************************/
/******************************************************************************/

/******************************************************************************/
/************************ Types Definitions ***********************************/
/******************************************************************************/

typedef struct verilog_template {
    uint32_t id;         // 0x0000, RO
    uint32_t revision;   // 0x0004, RO
    uint32_t buildtime;  // 0x0008, RO
    uint32_t test;       // 0x000C, RW
    uint32_t baseaddr;
}* verilog_template_t;

/******************************************************************************/
/************************ Functions Declarations ******************************/
/******************************************************************************/

extern int verilog_template_init(verilog_template_t* dev_ptr, uint32_t base_addr);
extern int verilog_template_deinit(verilog_template_t* dev_ptr);

/******************************************************************************/
/************************ Variable Declarations *******************************/
/******************************************************************************/

#ifdef __cplusplus
}
#endif

#endif  // _VERILOG_TEMPLATE_H_
