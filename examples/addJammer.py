#!/usr/bin/env python 
# -*- coding: utf-8 -*- 
# 
# Copyright 2024 fun. 
# 
# SPDX-License-Identifier: GPL-3.0-or-later 
# 
  
  
import numpy as np 
from gnuradio import gr 
  
class powerJammer(gr.sync_block): 
    def __init__(self, samp_rate, slotlen, min_amplitude, max_amplitude, pattern_frequency): 
        gr.sync_block.__init__(self, 
            name="powerJammer", 
            in_sig=None,  # No input signal required 
            out_sig=[np.complex64]  # Complex output signal 
        ) 
  
        self.samp_rate = samp_rate  # Sample rate in samples per second 
        self.slotlen = slotlen  # Length of each slot in samples 
        self.min_amplitude = min_amplitude  # Minimum amplitude of the noise 
        self.max_amplitude = max_amplitude  # Maximum amplitude of the noise 
        self.pattern_frequency = pattern_frequency  # Frequency of the pattern in Hz 
  
        self.samples_remaining = slotlen  # Samples left in the current slot 
        self.current_sample_index = 0  # To keep track of the current sample for pattern generation 
  
    def calculate_amplitude(self, n): 
        # Define a pattern for amplitude change, e.g., sinusoidal pattern 
        # A sinusoidal pattern will vary the amplitude between min_amplitude and max_amplitude 
        amplitude_range = self.max_amplitude - self.min_amplitude 
        return self.min_amplitude + amplitude_range * (0.5 * (1 + np.sin(2 * np.pi * self.pattern_frequency * n / self.samp_rate))) 
  
    def work(self, input_items, output_items): 
        out = output_items[0] 
  
        # Determine the number of output samples to generate 
        noutput_items = len(out) 
  
        for i in range(noutput_items): 
            if self.samples_remaining <= 0: 
                # Reset the slot and pattern index after each slot 
                self.samples_remaining = self.slotlen
