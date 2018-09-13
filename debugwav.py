#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 12 17:10:58 2018

@author: wader
"""

import urllib.request

print('Beginning file download with urllib2...')

url = 'https://github.com/rosehilmo/whale-detection/blob/master/newStrongCalls.wav'  
urllib.request.urlretrieve(url, 'newStrongCalls.wav')  