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

#include "verilog_template.h"
// #include "xil_io.h"
#include <stdlib.h>
#include <math.h>

void Xil_Out32(uint32_t addr, uint32_t data) {}

int Xil_In32(uint32_t addr) {
    return 0;
}

int verilog_template_init(verilog_template_t* dev_ptr, uint32_t base_addr) {
    if (dev_ptr == NULL)
        return -1;

    *dev_ptr = NULL;
    verilog_template_t dev = (verilog_template_t)calloc(1, sizeof(struct verilog_template));
    if (NULL == dev)
        return -2;

    dev->baseaddr = base_addr;

    // read write test
    {
        Xil_Out32(dev->baseaddr + offsetof(struct verilog_template, test), 0x55555555);
        dev->test = Xil_In32(dev->baseaddr + offsetof(struct verilog_template, test));

        if (dev->test != 0x55555555)
            return -4;

        Xil_Out32(dev->baseaddr + offsetof(struct verilog_template, test), 0xAAAAAAAA);
        dev->test = Xil_In32(dev->baseaddr + offsetof(struct verilog_template, test));

        if (dev->test != 0xAAAAAAAA)
            return -4;
    }

    // read instance info
    {
        dev->id = Xil_In32(dev->baseaddr + offsetof(struct verilog_template, id));

        if (dev->id != 0xF7DEC7A5)
            return -3;

        dev->revision = Xil_In32(dev->baseaddr + offsetof(struct verilog_template, revision));
        dev->buildtime = Xil_In32(dev->baseaddr + offsetof(struct verilog_template, buildtime));
    }

    *dev_ptr = dev;

    return 0;
}

int verilog_template_deinit(verilog_template_t* dev_ptr) {
    if (dev_ptr == NULL)
        return -1;

    free(*dev_ptr);
    *dev_ptr = NULL;

    return 0;
}
