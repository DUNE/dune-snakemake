rule test:
    output:
        a="test.txt",
        b="test2.txt"
    shell:
        """
        echo "test" > {output.a}
        touch {output.b}
        """

final_stages = [
    rules.test
]