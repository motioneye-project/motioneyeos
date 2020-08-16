# Taken from smmap/test/test_tutorial.py

import smmap
mman = smmap.SlidingWindowMapManager()
assert mman.num_file_handles() == 0
assert mman.mapped_memory_size() == 0
