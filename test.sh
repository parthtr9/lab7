CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission > taoutput.txt
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [[ -f "student-submission/ListExamples.java" ]]; then 
    echo "file found"
else
    echo "ListExamples.java not found"
    exit 1
fi

# jars
cp -r lib grading-area
#ListExamples
cp student-submission/ListExamples.java grading-area/
#TestListExamples
cp TestListExamples.java grading-area/

cd grading-area
javac -cp $CPATH *.java

if [ $? -ne 0 ]; then
    echo "compiler error"
    exit 1
else
    echo "compiled successfully"
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > JUnit-output.txt

lastline=$(cat JUnit-output.txt | tail -n 2 | head -n 1)
if [[ $lastline == OK* ]] ; then
        tests=$(echo $lastline | awk '{print $2}' | tr -d '()')
    echo $tests "/" $tests

else
    tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
    successes=$((tests - failures))

    echo "$successes / $tests"
fi
