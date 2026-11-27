package io.github.nevades.tasklane.card;

/**
 * Aggregated per-card counts (checklist items or comments).
 *
 * @param total number of rows for the card
 * @param done  number of completed checklist items; always 0 for comments
 */
public record CardCounts(Long cardId, long total, long done) {
}
