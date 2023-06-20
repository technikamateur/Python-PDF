import unittest

from src.cieshw_pdf import templating
from pathlib import Path

class Test(unittest.TestCase):
    def test_0_invalid_path(self):
        print("Testing invalid path")
        with self.assertRaises(FileNotFoundError):
            templating.pdf(Path("123456"))

    def test_1_empty_path(self):
        print("Testing empty path")
        with self.assertRaises(FileNotFoundError):
            templating.pdf(Path("./src"))

if __name__ == '__main__':
    # begin the unittest.main()
    unittest.main()