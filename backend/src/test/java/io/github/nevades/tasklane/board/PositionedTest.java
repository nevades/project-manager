package io.github.nevades.tasklane.board;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;

class PositionedTest {

    static final class Item implements Positioned {
        final String name;
        int position;

        Item(String name) {
            this.name = name;
        }

        @Override
        public int getPosition() {
            return position;
        }

        @Override
        public void setPosition(int position) {
            this.position = position;
        }
    }

    @Test
    void movesItemAndRenumbers() {
        Item a = new Item("a");
        Item b = new Item("b");
        Item c = new Item("c");
        List<Item> items = new ArrayList<>(List.of(a, b, c));

        Positioned.moveTo(items, a, 2);

        assertThat(items).extracting(i -> i.name).containsExactly("b", "c", "a");
        assertThat(items).extracting(i -> i.position).containsExactly(0, 1, 2);
    }

    @Test
    void clampsOutOfRangePositions() {
        Item a = new Item("a");
        Item b = new Item("b");
        List<Item> items = new ArrayList<>(List.of(a));

        Positioned.moveTo(items, b, 99);

        assertThat(items).extracting(i -> i.name).containsExactly("a", "b");
    }
}
