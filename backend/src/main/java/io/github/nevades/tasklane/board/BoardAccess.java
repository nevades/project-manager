package io.github.nevades.tasklane.board;

import io.github.nevades.tasklane.common.ApiErrors.ForbiddenException;
import io.github.nevades.tasklane.common.ApiErrors.NotFoundException;
import org.springframework.stereotype.Component;

/**
 * Central authorization checks for board resources. Non-members get a 404 so that board ids are not leaked.
 */
@Component
public class BoardAccess {

    private final BoardMemberRepository members;

    public BoardAccess(BoardMemberRepository members) {
        this.members = members;
    }

    public BoardMember requireMember(Long boardId, Long userId) {
        return members.findByBoardIdAndUserId(boardId, userId)
                .orElseThrow(() -> new NotFoundException("Board not found."));
    }

    public BoardMember requireOwner(Long boardId, Long userId) {
        BoardMember member = requireMember(boardId, userId);
        if (!member.isOwner()) {
            throw new ForbiddenException("Only the board owner can do that.");
        }
        return member;
    }
}
