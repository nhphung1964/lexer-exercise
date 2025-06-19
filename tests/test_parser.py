from utils import Parser


def test_001():
    source = """Var: main ;"""
    expected = "success"

    assert Parser(source).parse() == expected

def test_002():
    source = """Var main ;"""
    expected = "success"

    assert Parser(source).parse() == expected

def test_003():
    source = """func main ;"""
    expected = "success"
    result = Parser(source).parse()
    assert result == expected
