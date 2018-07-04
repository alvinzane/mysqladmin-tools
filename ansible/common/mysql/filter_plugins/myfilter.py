#!/usr/bin/env python
# coding=utf-8
import re


class FilterModule(object):
    @staticmethod
    def last_part(data):
        patten = re.compile(r'\.(\d+)$')
        if patten.search(data):
            return patten.search(data).group(1)
        return None

    def filters(self):
        """ returns a mapping of filters to methods """
        return {
            "last_part": self.last_part,
        }
