#include "gtest/gtest.h"
#include "math_operations.h"

TEST(AdditionTests, PositiveNumbers)
{
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(10, 20), 30);
}

TEST(AdditionTests, NegativeNumbers)
{
    EXPECT_EQ(add(-2, -3), -5);
    EXPECT_EQ(add(-5, 2), -3);
}

TEST(AdditionTests, Zero)
{
    EXPECT_EQ(add(0, 0), 0);
    EXPECT_EQ(add(0, 5), 5);
}

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
