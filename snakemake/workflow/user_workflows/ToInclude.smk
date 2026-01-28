rule test:
    output:
        "test.txt"
    shell:
        """
        echo "test" > {output}
        """

final_stages = [
    rules.test
]