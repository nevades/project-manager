package io.github.nevades.tasklane.board;

import java.util.List;

/**
 * An item with an explicit order inside its parent (lists on a board, cards in a list, checklist items).
 */
public interface Positioned {

    int getPosition();

    void setPosition(int position);

    /** Rewrites positions as 0..n-1 following the order of the given list. */
    static void renumber(List<? extends Positioned> items) {
        for (int i = 0; i < items.size(); i++) {
            items.get(i).setPosition(i);
        }
    }

    /** Moves {@code item} to {@code index} within {@code items}, clamping the index, then renumbers. */
    static <T extends Positioned> void moveTo(List<T> items, T item, int index) {
        items.remove(item);
        int target = Math.clamp(index, 0, items.size());
        items.add(target, item);
        renumber(items);
    }
}
