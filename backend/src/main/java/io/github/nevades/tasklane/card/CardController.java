package io.github.nevades.tasklane.card;

import io.github.nevades.tasklane.card.CardDtos.CardDetail;
import io.github.nevades.tasklane.card.CardDtos.CardSummary;
import io.github.nevades.tasklane.card.CardDtos.ChecklistItemRequest;
import io.github.nevades.tasklane.card.CardDtos.ChecklistItemResponse;
import io.github.nevades.tasklane.card.CardDtos.CommentRequest;
import io.github.nevades.tasklane.card.CardDtos.CommentResponse;
import io.github.nevades.tasklane.card.CardDtos.CreateCardRequest;
import io.github.nevades.tasklane.card.CardDtos.MoveCardRequest;
import io.github.nevades.tasklane.card.CardDtos.UpdateCardRequest;
import io.github.nevades.tasklane.card.CardDtos.UpdateChecklistItemRequest;
import io.github.nevades.tasklane.security.AppUserDetails;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class CardController {

    private final CardService service;

    public CardController(CardService service) {
        this.service = service;
    }

    @PostMapping("/lists/{listId}/cards")
    @ResponseStatus(HttpStatus.CREATED)
    public CardSummary createCard(@PathVariable Long listId, @Valid @RequestBody CreateCardRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        return service.createCard(listId, request.title(), user.getId());
    }

    @GetMapping("/cards/{cardId}")
    public CardDetail getCard(@PathVariable Long cardId, @AuthenticationPrincipal AppUserDetails user) {
        return service.getCard(cardId, user.getId());
    }

    @PutMapping("/cards/{cardId}")
    public CardDetail updateCard(@PathVariable Long cardId, @Valid @RequestBody UpdateCardRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        return service.updateCard(cardId, request, user.getId());
    }

    @PostMapping("/cards/{cardId}/move")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void moveCard(@PathVariable Long cardId, @Valid @RequestBody MoveCardRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        service.moveCard(cardId, request, user.getId());
    }

    @DeleteMapping("/cards/{cardId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteCard(@PathVariable Long cardId, @AuthenticationPrincipal AppUserDetails user) {
        service.deleteCard(cardId, user.getId());
    }

    @PostMapping("/cards/{cardId}/checklist")
    @ResponseStatus(HttpStatus.CREATED)
    public ChecklistItemResponse addChecklistItem(@PathVariable Long cardId,
            @Valid @RequestBody ChecklistItemRequest request, @AuthenticationPrincipal AppUserDetails user) {
        return service.addChecklistItem(cardId, request.content(), user.getId());
    }

    @PutMapping("/checklist-items/{itemId}")
    public ChecklistItemResponse updateChecklistItem(@PathVariable Long itemId,
            @Valid @RequestBody UpdateChecklistItemRequest request, @AuthenticationPrincipal AppUserDetails user) {
        return service.updateChecklistItem(itemId, request, user.getId());
    }

    @DeleteMapping("/checklist-items/{itemId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteChecklistItem(@PathVariable Long itemId, @AuthenticationPrincipal AppUserDetails user) {
        service.deleteChecklistItem(itemId, user.getId());
    }

    @PostMapping("/cards/{cardId}/comments")
    @ResponseStatus(HttpStatus.CREATED)
    public CommentResponse addComment(@PathVariable Long cardId, @Valid @RequestBody CommentRequest request,
            @AuthenticationPrincipal AppUserDetails user) {
        return service.addComment(cardId, request.body(), user.getId());
    }

    @DeleteMapping("/comments/{commentId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteComment(@PathVariable Long commentId, @AuthenticationPrincipal AppUserDetails user) {
        service.deleteComment(commentId, user.getId());
    }
}
