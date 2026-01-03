import React, { useEffect, useState, useCallback } from 'react';

import {
  DndContext,
  DragOverlay,
  PointerSensor,
  useSensor,
  useSensors,
  closestCenter,
} from '@dnd-kit/core';
import {
  SortableContext,
  useSortable,
  arrayMove,
  horizontalListSortingStrategy,
} from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';

import CardItem from './CardItem';

async function saveListOrder(ids) {
  try {
    const tokenEl = document.querySelector("meta[name='csrf-token']");
    const token = tokenEl ? tokenEl.content : '';
    const res = await fetch('/api/v1/lists/reorder', {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        'X-CSRF-Token': token,
      },
      body: JSON.stringify({ list_ids: ids }),
      credentials: 'same-origin',
    });

    if (!res.ok) {
      console.error('Failed to reorder', res.statusText);
      return false;
    }
    return true;
  } catch (e) {
    console.error('Failed to update list order', e);
    return false;
  }
}

function SortableList({ list }) {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } = useSortable({
    id: list.id,
  });
  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.6 : 1,
  };

  return (
    <div ref={setNodeRef} style={style} {...attributes} {...listeners} className="list">
      <div className="list_header">
        <h2 className="list_header_title">{list.title}</h2>
        <div className="list_header_action">
          <a
            href={`/list/${list.id}`}
            data-method="delete"
            data-confirm={`Are you sure you want to remove '${list.title}'?`}
          >
            <i className="fas fa-trash" />
          </a>
          <a href={`/list/${list.id}/edit`}>
            <i className="fas fa-pen" />
          </a>
        </div>
      </div>
      <div className="cardWrapper">
        {list.cards?.map((card) => (
          <CardItem key={card.id} listId={list.id} card={card} />
        ))}
        <div className="addCard">
          <i className="far fa-plus-square" />
          <a href={`/list/${list.id}/card/new`} className="addCard_link">
            Add a card...
          </a>
        </div>
      </div>
    </div>
  );
}

function DragPreview({ list }) {
  if (!list) return null;

  // TODO: ドラッグ中のプレビュー表示
  return null;
}

export default function ListLane({ lists }) {
  const [listLanes, setListLanes] = useState(lists || []);
  const [dragId, setDragId] = useState(null);

  useEffect(() => {
    setListLanes(lists || []);
  }, [lists]);

  const sensors = useSensors(useSensor(PointerSensor));

  const handleDragStart = useCallback((event) => {
    setDragId(event.active.id);
  }, []);

  const handleDragEnd = useCallback((event) => {
    const { active, over } = event;
    if (!over || String(active.id) === String(over.id)) {
      setDragId(null);
      return;
    }
    setListLanes((currentListLanes) => {
      const oldIndex = currentListLanes.findIndex((ll) => String(ll.id) === String(active.id));
      const newIndex = currentListLanes.findIndex((ll) => String(ll.id) === String(over.id));
      if (oldIndex === -1 || newIndex === -1) return currentListLanes;

      const newListLanes = arrayMove(currentListLanes, oldIndex, newIndex);

      // 並び順を保存（非同期で失敗した場合は元に戻す）
      (async (prev) => {
        const listIds = newListLanes.map((ll) => ll.id);
        const success = await saveListOrder(listIds);
        if (!success) {
          setListLanes(prev);
        }
      })(currentListLanes);

      return newListLanes;
    });

    setDragId(null);
  }, []);

  return (
    <DndContext
      sensors={sensors}
      collisionDetection={closestCenter}
      onDragStart={handleDragStart}
      onDragEnd={handleDragEnd}
    >
      <SortableContext
        items={listLanes.map((ll) => ll.id)}
        strategy={horizontalListSortingStrategy}
      >
        <div className="listWrapper">
          {listLanes.map((list) => (
            <SortableList key={list.id} list={list} />
          ))}
        </div>
      </SortableContext>
      <DragOverlay>
        {dragId ? (
          <DragPreview list={listLanes.find((ll) => String(ll.id) === String(dragId))} />
        ) : null}
      </DragOverlay>
    </DndContext>
  );
}
